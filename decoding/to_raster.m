%% Load event amd neural data

event_data_file_path = '/Users/michaelzhou/Desktop/chang_neural_decoding/data/raw_data/events_Data_041621.mat'; % '/Users/michaelzhou/Desktop/chang_neural_decoding/data/brainEventData06042019.mat';
spike_data_file_path = '/Users/michaelzhou/Desktop/chang_neural_decoding/data/raw_data/brainSpike_Data06042019.mat';

spike_data = load( spike_data_file_path );

event_data = load( event_data_file_path );
% event_data = event_data.event_data;

%% Convert to raster format

% Valid dates for object: 020918 and after, index 13 for date
% Valid dates for eyes / face: all days

% Save data to this dir -- takes ~8 min. to complete for -.5s to 1s. ~20
% min. for -1.5 to 1.5s.

%%% Parameters %%%

% Start date
start_date = 13;  % MODIFY, 13 is for object data
if start_date == 1
    start_str = '_n1201';
else
    start_str = '_n911';
end

% Time bin for event
time_bin = [-1:.001:1];  % MODIFY

% Time threshold of each event
event_duration = .1;  % MODIFY
event_str = num2str(round(event_duration*10));

% Events to decode

% right_nonsocial_object_eyes_nf_matched, 
decoding_events = {'whole_face', 'right_nonsocial_object_whole_face_matched'};  % 'whole_face', 'face', 'eyes_nf', 'right_nonsocial_object_eyes_nf_matched',
                                                                    % right_nonsocial_object_whole_face_matched.  % MODIFY
decoding_str = '';
if ismember('whole_face', decoding_events)
    decoding_str = [decoding_str 'WF'];  % Whole Face
end
if ismember('face', decoding_events)
    decoding_str = [decoding_str 'NEF'];  % Non-eyes Face
end
if ismember('eyes_nf', decoding_events)
    decoding_str = [decoding_str 'E'];  % Eyes
end
if ismember('right_nonsocial_object_eyes_nf_matched', decoding_events) 
    decoding_str = [decoding_str 'OE'];  % Object-eyes
end
if ismember('right_nonsocial_object_whole_face_matched', decoding_events)  
    decoding_str = [decoding_str 'OF'];  % Object-face
end

outdir = '/Users/michaelzhou/Desktop/chang_neural_decoding/data/raster_format_1000start_1000_end/';
outpath = [outdir 'raster_format_' decoding_str '_threshdur' event_str start_str '_1000start_1000end'];  % MODIFY

if ~exist(outpath, 'dir')
    mkdir(outpath)
end

% Convert to raster format
run_ids = event_data(1).runs;
run_dates = cellfun( @(x) x(1:8), run_ids, 'un', 0 );
run_nums = cellfun( @(x) strrep(x, '.mat', ''), run_ids, 'un', 0 );
run_nums = cellfun( @(x) str2double(x(19:end)), run_nums );
assert( ~any(isnan(run_nums)) ); 

units = spike_data.spike_data;
unit_dates = arrayfun( @(x) x.date, units, 'un', 0 );

unit_numbers_by_session = spike_data.spike_data(1).sessions;
session_nums = spike_data.event_data(1).session_num;

% Find the index of the set of event times corresponding to 'm1eyes'.
% You can change this to any of the event types in `event_types`.
event_types = event_data(1).type;

% % For multiple events -- *
multiple_event_data = {};

for i = 1:numel(decoding_events)
    [~, event_ind] = ismember( decoding_events{i}, event_types );
    multiple_event_data{end+1} = event_data(event_ind);
end

% cell count
cell_count = 0;

for i = start_date:numel(session_nums)
    
    curr_session_nums = session_nums{i};
    
    curr_run_dates = run_dates(curr_session_nums);
    curr_run_nums = run_nums(curr_session_nums);
    
    % Loop through event types (e.g. eyes, face, object)
    curr_event_times = [];
    labels = [];
    for s = 1:numel(multiple_event_data)
    
        curr_event_name = decoding_events{s};
        curr_event_type = multiple_event_data{s};
        
        % event duration / event times
        curr_event_durs_temp = curr_event_type.dur(curr_session_nums);
        curr_event_times_temp = curr_event_type.time(curr_session_nums);

        % get event durations where isnan for event times
        isnan_idx = cellfun(@(x) ~isnan(x), curr_event_times_temp, 'UniformOutput', false);  % remove NaNs
        curr_event_durs_isnan = cellfun(@(x,y) x(y), curr_event_durs_temp, isnan_idx, 'un', 0);

        % isnan event times
        curr_event_times_isnan = cellfun(@(x) x(~isnan(x)), curr_event_times_temp, 'UniformOutput', false);  % remove NaNs
        
        % get time of events above a certain duration
        time_idx = cellfun(@(x) x > event_duration, curr_event_durs_isnan, 'UniformOutput', false);
        curr_event_times_thresh = cellfun(@(x,y) x(y), curr_event_times_isnan, time_idx, 'un', 0);
        
        % Event labels
        total_num_events = sum(cellfun('size', curr_event_times_thresh, 2));
        labels = [labels, repmat({curr_event_name}, 1, total_num_events)];
        
        % Event times of all event types
        curr_event_times = [curr_event_times, curr_event_times_thresh];
        
    end
        
    % All the cells that were recorded on the date corresponding
    % to this run.
    date_ind =  ismember( unit_dates, curr_run_dates{1} );
    units_this_date = units(date_ind);
    
    % Loop through cells
    for k = 1:numel(units_this_date)  % units_this_date does not include all 1201 neurons 
        
        % cell count
        cell_count = cell_count + 1;
        
        % Neuron info. - to calculate PSTH
        spike_times = units_this_date(k).times;
        
        % Neuron info. - to save
        uuid = units_this_date(k).uuid;
        region = units_this_date(k).region;
        date = units_this_date(k).date;
        rating = units_this_date(k).rating;
        
        % Raster format
        raster_data = [];

        % Loop through event sessions (1-10)
        for j = 1:numel(curr_event_times)

            % The eye event times for this particular run.
            event_times = curr_event_times{j};

            % Check for nans
            event_times = event_times(~isnan(event_times));

            % Compute the psth for each individual event. 
            for l = 1:numel(event_times)
                event = event_times(l);  
                raster_data(end+1,:) = histcounts(spike_times, event + time_bin);  % psth

            end

        end

        % Save neuron info.
        raster_labels = struct('event_id', {labels});  
        raster_site_info = struct('uuid', uuid, 'region', region, 'date', date, 'rating', rating);
        
        % Debugging
        assert(size(raster_data, 1) == size(raster_labels.event_id, 2), 'mismatched dimensions')
        
        % Save in raster format (data, labels, site_info)
        save(fullfile(outpath, ['cell', num2str(cell_count)]), 'raster_data', 'raster_labels', 'raster_site_info');
        
    end

    
end