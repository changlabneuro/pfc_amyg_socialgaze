template_script_str = fileread( 'cluster_template_050321.m' );

%%

% % Parameters
% start_date = 13; % start from 13 for object data
% event_duration = .1; 
% decoding_events = {?eyes_nf?, ?right_nonsocial_object_eyes_nf_matched?}; % ?whole_face?, ?face?, ?eyes_nf?, ?right_nonsocial_object_eyes_nf_matched?,
%                                      % right_nonsocial_object_whole_face_matched 
% bin_width = 150;
% step_size = 50;

script_name_prefix = 'cluster_scripts/cluster_run_';

event_durations = [0.1];
decoding_params = {[150, 50]};  % [100, 10], [150, 50]
decoding_event_types = { {'eyes_nf', 'right_nonsocial_object_eyes_nf_matched'}, ...
                         {'whole_face', 'right_nonsocial_object_whole_face_matched'}, ...
                         {'face', 'eyes_nf'}, ...
                         {'reward-1', 'reward-3'} };
% {'eyes_nf', 'right_nonsocial_object_eyes_nf_matched'}, ...
%                          {'whole_face', 'right_nonsocial_object_whole_face_matched'}, ...
%                          {'face', 'eyes_nf'}
match_samples_flags = [0 1];
                 
cs = combvec( ...
    1:numel(event_durations) ...
  , 1:numel(decoding_params) ...
  , 1:numel(decoding_event_types) ...
  , 1:numel(match_samples_flags) ...
);

%%

for i = 1:size(cs, 2)
  % For each combination
  
  c = cs(:, i);
  event_duration = event_durations(c(1));
  
  parameters = decoding_params{c(2)};
  bin_width = parameters(1);
  step_size = parameters(2);
  
  decoding_events = decoding_event_types{c(3)};
  match_samples = match_samples_flags(c(4));
  
  template_str = [
    "event_duration = %0.5f;"
    "bin_width = %d;"
    "step_size = %d;"
    "decoding_events = {'%s', '%s'};"
    "match_samples = %d;"
  ];

	template_str = strjoin( template_str, newline );

  param_str = compose( template_str ...
    , event_duration ...
    , bin_width ...
    , step_size ...
    , decoding_events{1}, decoding_events{2} ...
    , match_samples ...
  );

  script_contents = sprintf( '%s\n%s', param_str, template_script_str );

  script_name = sprintf( '%s%d.m', script_name_prefix, i );
  fid = fopen( script_name, 'w' );
  fwrite( fid, script_contents );
  fclose( fid );
end

%%

script_names = {};
for i = 1:size(cs, 2)
    string = ["cluster_scripts/cluster_run_" + i + ".m"];
    script_names{i} = string;
end

template = fileread( 'submission_template.sh' );
for i = 1:numel(script_names)
filled_in_template = char( compose(template, script_names{i}) );
script_name = strrep( script_names{i}, '.m', '.sh' );
fid = fopen( script_name, 'w' );
fwrite( fid, filled_in_template );
fclose( fid );
end