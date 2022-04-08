%% Load toolbox

% add the path to the NDT so add_ndt_paths_and_init_rand_generator can be called
toolbox_basedir_name = '/gpfs/milgram/scratch60/chun/mz456/ndt.1.0.4'; 
addpath(toolbox_basedir_name);
 
% add the NDT paths using add_ndt_paths_and_init_rand_generator
add_ndt_paths_and_init_rand_generator

% add supplementary toolbox
supp_toolbox_basedir_name = '/gpfs/milgram/scratch60/chun/mz456/NDT_supplemental_code/';
addpath(supp_toolbox_basedir_name);
addpath([supp_toolbox_basedir_name 'additional_tools/']);

%% Initialize Parameters

% Keys:
% alldays - including days from 1-13
% threshdur1 - .1s threshold, threshdur7 - .7s threshold
% F - non-eye face
% E - eyes
% O - object
% WF - whole face, including eyes

% % Parameters
% start_date = 1; % start from 13 for object data
% event_duration = .1; 
% decoding_events = {'reward-1' 'reward-3'};  
% bin_width = 100;
% step_size = 50;

% Create strings (matched with to_raster.m)

% Start string - default
start_str = '_n1201_';

% Time threshold of each event
event_str = num2str(round(event_duration*10));

% Events to decode
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
    start_str = '_n911_';
end
if ismember('right_nonsocial_object_whole_face_matched', decoding_events)  
    decoding_str = [decoding_str 'OF'];  % Object-face
    start_str = '_n911_';
end
if ismember('reward-1', decoding_events)
    decoding_str = [decoding_str 'low'];
end
if ismember('reward-2', decoding_events)
    decoding_str = [decoding_str 'med'];
end
if ismember('reward-3', decoding_events)
    decoding_str = [decoding_str 'high'];
end

% Get directory name
outdir = '/gpfs/milgram/scratch60/chun/mz456/chang_neural_decoding/data/raster_format_1000start_1000_end/';
raster_file_directory_name = [outdir 'raster_format_' decoding_str '_threshdur' event_str start_str '1000start_1000end'];

%% Decoding results: Permutation test for all 4 regions

% Specify flags
sig_cells = 0;  % Flag: 1 for only significant cells (from AUC), 0 otherwise 
permute = 1; % Flag: 1 for run permutation
% make_subplot = 1; % Flag: 1 for plot on same plot
% match_samples = 0;  % Flag 1: match n across ROIs

% Permutation testing / plotting
dirpath = '/gpfs/milgram/scratch60/chun/mz456/chang_neural_decoding/data/';

% CHANGE PATH
binned_data_name = ['raster_format_1000start_1000_end/raster_format_' decoding_str '_threshdur' event_str start_str '1000start_1000end_binned_data_' num2str(bin_width) 'ms_bins_' num2str(step_size) 'ms_sampled'];
load(fullfile(dirpath, binned_data_name));

regions = {'bla', 'dmpfc', 'accg', 'ofc'};  % 'bla', 'dmpfc', 'accg', 'ofc'
cv = 15;

cells = '';
if sig_cells
    load('../AUC_infos_eyes-neface')  % '../AUC_infos_eyes-mRobj.mat'
    sig_cells_id_temp = {uuidbla, uuiddmpfc, uuidaccg, uuidofc};
    sig_cells_id = cellfun( @(x) str2double(x), sig_cells_id_temp, 'UniformOutput', false);
    cells = 'sig';
end

all_sites = [];
if match_samples
    for s = 1:numel(regions)
        region = regions{s};
        region_sites = find(strcmp(binned_site_info.region, region) == 1);
        cv_sites = find_sites_with_k_label_repetitions(binned_labels.event_id, cv);
        sites = intersect(region_sites, cv_sites);
        all_sites(end+1) = length(sites);
    end
    n = min(all_sites);
    match_str = '_match_';
else
    n = -1;
    match_str = '';
end

% CHANGE
prefix_file = [decoding_str cells '_threshdur' event_str start_str match_str num2str(bin_width) 'ms_bins_' num2str(step_size) 'ms_sampled'];  
prefix_shuffled = ['null_dist/' prefix_file];

for s = 1:numel(regions)
    
    region = regions{s};
    region_sites = find(strcmp(binned_site_info.region, region) == 1);
    cv_sites = find_sites_with_k_label_repetitions(binned_labels.event_id, cv);
    sites = intersect(region_sites, cv_sites);
    
    % ['Sites1: ' num2str(length(sites))]
    
    if sig_cells
        uuid = binned_site_info.uuid;
        uuid_sites = uuid(sites);
        overlap_ids = intersect(uuid_sites, sig_cells_id{s});
        sites = find(ismember(uuid, overlap_ids) == 1);
        % ['Sites2: ' num2str(length(sites))]
    end
    
    if permute
        for i = 256:1000
            i
            run_permutation(i, sites, region, dirpath, binned_data_name, prefix_shuffled, cv, n); 
        end
    end

end