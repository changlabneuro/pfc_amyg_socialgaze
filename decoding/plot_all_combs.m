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

%% Decoding results: Permutation test for all combinations

event_durations = [0.1];
decoding_params = {[150, 50]};  % [100, 10], [150, 50]
decoding_event_types = { {'eyes_nf', 'right_nonsocial_object_eyes_nf_matched'}, ...
                         {'whole_face', 'right_nonsocial_object_whole_face_matched'}, ...
                         {'face', 'eyes_nf'}, ...
                         {'reward-1', 'reward-3'} };
% {'eyes_nf', 'right_nonsocial_object_eyes_nf_matched'}, ...
%                          {'whole_face', 'right_nonsocial_object_whole_face_matched'}, ...
%                          {'face', 'eyes_nf'}
match_samples_flags = [0 1];  % [0 1]

                 
cs = combvec( ...
    1:numel(event_durations) ...
  , 1:numel(decoding_params) ...
  , 1:numel(decoding_event_types) ...
  , 1:numel(match_samples_flags) ...
);

for i = 1:size(cs, 2)
    
    % For each combination
    c = cs(:, i);
    event_duration = event_durations(c(1));

    parameters = decoding_params{c(2)};
    bin_width = parameters(1);
    step_size = parameters(2);

    decoding_events = decoding_event_types{c(3)};
    match_samples = match_samples_flags(c(4));

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

    % Specify flags
    sig_cells = 0;  % Flag: 1 for only significant cells (from AUC), 0 otherwise 
    permute = 0; % Flag: 1 for run permutation
    make_subplot = 1; % Flag: 1 for plot on same plot
    
    % Set plot size;
    x0=600;
    y0=600;
    width=800;
    height=600;
    set(gcf,'position',[x0,y0,width,height])

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

        % create a plot_standard_results_object that has the directory with the real results
        dirpath = '/gpfs/milgram/scratch60/chun/mz456/chang_neural_decoding/data/';
        result_names{1} = fullfile(dirpath, [prefix_shuffled region '_binned_data_results.mat']);
        plot_obj = plot_standard_results_object(result_names);

        % create the names of directories that contain the shuffled data for creating null distributions
        % (this is a cell array so that multiple p-values are created when comparing results)
        pval_dir_name{1} = fullfile(dirpath, [prefix_shuffled region '_shuff_results/']);
        plot_obj.p_values = pval_dir_name;

        % error bars
        plot_obj.errorbar_file_names = result_names;
        plot_obj.errorbar_stdev_multiplication_factor = 1 / sqrt(length(sites));  % SEM
        plot_obj.errorbar_edge_transparency_level = .5;

        % use data from all time bins when creating the null distribution
        plot_obj.collapse_all_times_when_estimating_pvals = 0;
        collapsed_str = '';
        if plot_obj.collapse_all_times_when_estimating_pvals == 1
            collapsed_str = '_collapsed';
        end
        plot_obj.add_pvalue_latency_to_legends_alignment = 0;

        % get null dist. piot info
        path = pval_dir_name{1};
        [xs, null_dist] = get_null(path);

        % subplot
        if make_subplot
            subplot(2, 2, s)
            sgtitle([decoding_events{1} ' vs. ' decoding_events{2}], 'Interpreter','none', 'FontSize', 23) 
        end

        % plot the results as usual
        plot_obj.plot_time_intervals.alignment_event_time = 1000;
        plot_obj.significant_event_times = 0;
        plot_obj.plot_time_intervals.alignment_type = 2;
        % plot_obj.the_axis = [-1000 1000 45 80];
        plot_obj.legend_names = {'Significant'};
        plot_obj.the_axis = [-1000 1000 44 85];
        plot_obj.plot_results;
        % ylim([44 inf])

        hold on
        % plot null
        plot(xs - 1000 + bin_width / 2, null_dist, '--r')
        legend(['Significant'])
        hold off

        if match_samples
            title([region ' (n = ' num2str(n, '%03d') ')'], 'FontSize', 16)
        else
            title([region ' (n = ' num2str(numel(sites), '%03d') ')'], 'FontSize', 16)
        end

        save_plot_path = ['/gpfs/milgram/scratch60/chun/mz456/chang_neural_decoding/results/plots/' prefix_file];
        if ~exist(save_plot_path, 'dir')
           mkdir(save_plot_path)
        end

        if make_subplot
            set(gcf, 'Renderer', 'painters')
            % saveas(gcf, [save_plot_path '/permutation_decoding_cv' cv '_' 'subplot' '_start1000_end1000' collapsed_str '.png']);
            saveas(gcf, [save_plot_path '/permutation_decoding_cv' cv '_' 'subplot' '_start1000_end1000' collapsed_str '.epsc']);
        else
            saveas(gcf, [save_plot_path '/permutation_decoding_cv' cv '_' region '_start1000_end1000.png']);
        end
    end
end