% %% Permutation test
% 
% cd /Users/michaelzhou/Desktop/Ethan_Data/results/
% 
% % the following parameters are hard coded but could be input arguments to this function
% specific_binned_labels_names = 'stimulus_id';  % use object identity labels to decode which object was shown 
% num_cv_splits = 10;     % use 20 cross-validation splits 
% binned_data_file_name = 'Ethan_Data_ETOH_10ms_PT_binned_data_90ms_bins_30ms_sampled.mat'; % use the data that was previously binned 
%  
% % the name of where to save the results
% save_file_name = 'Ethan_Data_ETOH_10ms_PT_binned_data_results';
%  
%  
% % create the basic objects needed for decoding
% ds = basic_DS(binned_data_file_name, specific_binned_labels_names,  num_cv_splits); % create the basic datasource object
% the_feature_preprocessors{1} = zscore_normalize_FP;  % create a feature preprocess that z-score normalizes each feature
% the_classifier = max_correlation_coefficient_CL;  % select a classifier
% the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);  
%  
%  
% % we will also greatly speed up the run-time of the analysis by not creating a full TCT matrix 
% % (i.e., we are only training and testing the classifier on the same time bin)
% the_cross_validator.test_only_at_training_times = 1;  
%  
%  
% % run the decoding analysis and save the results
% DECODING_RESULTS = the_cross_validator.run_cv_decoding; 
%  
% % save the results
% save(save_file_name, 'DECODING_RESULTS');

% Shuffled

function run_permutation(shuff_num, sites, region, inpath, binned_data_name, prefix_shuffled, cv, n)

% % cd /Users/michaelzhou/Desktop/Ethan_Data/results/
% dirpath = '/Users/michaelzhou/Desktop/chang_neural_decoding/data/';
% 
% % brain region
% region = 'ofc';

% flag to specify whether we want a sample of neurons
if n > 0
    sample = 1;
else
    sample = 0;
end

% the following parameters are hard coded but could be input arguments to this function
specific_binned_labels_names = 'event_id';  % use object identity labels to decode which object was shown 
num_cv_splits = cv;     % use 20 cross-validation splits 
binned_data_file_name = fullfile(inpath, binned_data_name); % use the data that was previously binned 
 
% the name of where to save the results
save_file_name = [region '_binned_data_results'];
 
% create the basic objects needed for decoding
ds = basic_DS(binned_data_file_name, specific_binned_labels_names,  num_cv_splits); % create the basic datasource object
ds.sites_to_use = sites; % find(strcmp(binned_site_info.region, region) == 1);

if sample
    ds.num_resample_sites = n;  % number of samples
    n
end

the_feature_preprocessors{1} = zscore_normalize_FP;  % create a feature preprocess that z-score normalizes each feature
the_classifier = max_correlation_coefficient_CL;  % select a classifier
 
 
if shuff_num == 0
 
    'Currently running regular decoding results'
 
     % if running the regular results, create the regular cross-validator
     the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);  
     the_cross_validator.num_resample_runs = 1000;
     
     % don't show progress to reduce visual clutter while the code is running
     the_cross_validator.display_progress.zero_one_loss = 0;  
     the_cross_validator.display_progress.resample_run_time = 0;
 
     % the name of where to save the results for regular (non-shuffled) decoding results as before
     save_file_name = fullfile(inpath, [prefix_shuffled region '_binned_data_results']);
 
else
 
    'Currently running shuffled label decoding results (data for the null distribution)'
 
    ds.randomly_shuffle_labels_before_running = 1;  % randomly shuffled the labels before running
 
    % create the cross validator as before
    the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);  
 
    the_cross_validator.num_resample_runs = 100; 
 
    % don't show progress to reduce visual clutter while the code is running
    the_cross_validator.display_progress.zero_one_loss = 0;  
    the_cross_validator.display_progress.resample_run_time = 0;
 
    % save the results with the appropriate name to the shuff_results/ directory
    save_file_name = fullfile(inpath, [prefix_shuffled region '_shuff_results/run_' num2str(shuff_num, '%04d')]);
 
end
 
outdir = fileparts(save_file_name);
if ~exist(outdir, 'dir')
   mkdir(outdir)
end

% we will also greatly speed up the run-time of the analysis by not creating a full TCT matrix 
% (i.e., we are only training and testing the classifier on the same time bin)
the_cross_validator.test_only_at_training_times = 1;  
 
% run the decoding analysis and save the results
DECODING_RESULTS = the_cross_validator.run_cv_decoding; 
 
% save the results
save(save_file_name, 'DECODING_RESULTS'); 

end
