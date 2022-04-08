%% Load files and create "Data" variable

files = dir('*.mat');
filesname = {files.name};
sortedfilesname = natsort(filesname);
characterfile=char(sortedfilesname);

% stringfile is the file names in right order: 1, 2, ... 9, 10, 11
stringfile=deblank(string(characterfile));

% datafile is the first 8 digit of the file names (Data)
datefile=string(characterfile(:,1:8));

% date is distinct experiment days
date=unique(datefile);

for i=1:length(date)
    string_binary=strfind(stringfile,date(i));
    string=cellfun(@(a)~isempty(a) && a>0,string_binary);
    stringindex=find(string==1);
    
    for j=stringindex(1):stringindex(end)
        
        filename=cellstr(extractBefore(stringfile(j),'.mat'));
        filename2=stringfile(j);
        
        day_char=char(strcat('data_',date(i)));
        run_char=char(strcat('run_',num2str(j)));
        
        Data.(day_char).(run_char).spikes = bfw.load1( 'spikes', filename, conf);
        Data.(day_char).(run_char).rois = bfw.load1( 'rois', filename, conf );
        Data.(day_char).(run_char).position = bfw.load1( 'position', filename, conf );
        Data.(day_char).(run_char).offsets = bfw.load1( 'offsets', filename, conf );
        Data.(day_char).(run_char).isfixation = bfw.load1( 'raw_eye_mmv_fixations', filename, conf); 
        Data.(day_char).(run_char).time = bfw.load1( 'time', filename, conf); 
        
        Data.(day_char).(run_char).events = load(append('/Volumes/Backup 4TB/BRAINS Recording/Modeling/Data/Kuro/intermediates/events/',filename2)).var;
        
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Data.mat','Data','-v7.3')


%% Get data

ROI= 'eyes_nf';
ROI_obj_right='right_nonsocial_object';

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

% get the field names
fieldname=fieldnames(Data);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    field_run=fieldnames(Data.(field_id));
   
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        
        % Get offsets
        Offsets_m1=Data.(field_id).(run_id).offsets.m1;
        Offsets_m2=Data.(field_id).(run_id).offsets.m2;
        Offsets_m2_m1=Data.(field_id).(run_id).offsets.m2_to_m1;
        
        % ROI info for eyes
        roi_m1=Data.(field_id).(run_id).rois.m1.rects(ROI);
        roi_m2=Data.(field_id).(run_id).rois.m2.rects(ROI);
        roi_m1([1,3])=roi_m1([1,3])+Offsets_m1(1);
        roi_m1([2,4])=roi_m1([2,4])+Offsets_m1(2);
        roi_m2([1,3])=Offsets_m2_m1(1)-(roi_m2([1,3])+Offsets_m2(1));
        roi_m2([2,4])=roi_m2([2,4])+Offsets_m2(2);
        
        % ROI info for right object
        roi_right_object=Data.(field_id).(run_id).rois.m1.rects(ROI_obj_right);
        roi_right_object([1,3])=roi_right_object([1,3])+Offsets_m1(1);
        roi_right_object([2,4])=roi_right_object([2,4])+Offsets_m1(2);
        
        % Get the center of ROI for eyes
        center_roi_m1=[(roi_m1(1)+roi_m1(3))/2 (roi_m1(2)+roi_m1(4))/2];
        center_roi_m2=[(roi_m2(1)+roi_m2(3))/2 (roi_m2(2)+roi_m2(4))/2];
        
        % Get the center of right object
        center_roi_right_object=[(roi_right_object(1)+roi_right_object(3))/2 (roi_right_object(2)+roi_right_object(4))/2];
        
        % Coordinates of gaze positions
        x_m1=Data.(field_id).(run_id).position.m1(1,:)+Offsets_m1(1);
        y_m1=Data.(field_id).(run_id).position.m1(2,:)+Offsets_m1(2);
        
        x_m2= Offsets_m2_m1(1)-(Data.(field_id).(run_id).position.m2(1,:)+Offsets_m2(1));
        y_m2= Data.(field_id).(run_id).position.m2(2,:)+Offsets_m2(2);
        
        % find m1 fixations        
        m1_fixation_idx=vertcat(find(contains(Data.(field_id).(run_id).events.labels(:,1),'m1')),find(contains(Data.(field_id).(run_id).events.labels(:,1),'mutual')));
        
        for i=1:length(m1_fixation_idx)
        
        fixation_id=horzcat('fixation_',num2str(i));
        
        % in ms
        start_index=Data.(field_id).(run_id).events.events(m1_fixation_idx(i),1);
        end_index=Data.(field_id).(run_id).events.events(m1_fixation_idx(i),2);
        time_index_start=Data.(field_id).(run_id).events.events(m1_fixation_idx(i),4);
        time_index_end=Data.(field_id).(run_id).events.events(m1_fixation_idx(i),5);
        fixation_duration(i)=Data.(field_id).(run_id).events.events(m1_fixation_idx(i),3);
        
        % mean distance within the whole fixation period          
        x_m1_mean(i)=nanmean(x_m1(start_index:end_index));
        y_m1_mean(i)=nanmean(y_m1(start_index:end_index));
        
        x_m2_mean(i)=nanmean(x_m2(start_index:end_index));
        y_m2_mean(i)=nanmean(y_m2(start_index:end_index));
        
        m2_distance = sqrt((x_m2(start_index:end_index)-x_m2_mean(i)).^2+(y_m2(start_index:end_index)-y_m2_mean(i)).^2);
        m2_percentage (i) = length(find(m2_distance<=px_per_deg))/length(m2_distance);
        
        clear m2_distance
        
        mean_distance_m1(i)=sqrt((x_m1_mean(i)-center_roi_m1(1)).^2+(y_m1_mean(i)-center_roi_m1(2)).^2);
        mean_distance_m2(i)=sqrt((x_m2_mean(i)-center_roi_m2(1)).^2+(y_m2_mean(i)-center_roi_m2(2)).^2);
        
        distance_m1m2(i)=sqrt((x_m1_mean(i)-x_m2_mean(i)).^2+(y_m1_mean(i)-y_m2_mean(i)).^2);
        
        control_distance_m1(i)=sqrt((x_m1_mean(i)).^2+(y_m1_mean(i)).^2);
        control_distance_m2(i)=sqrt((x_m2_mean(i)).^2+(y_m2_mean(i)).^2);
        
        control_obj_right(i)=sqrt((x_m1_mean(i)-center_roi_right_object(1)).^2+(y_m1_mean(i)-center_roi_right_object(2)).^2);
                
        % count spikes for each cell
        for p=1:size(Data.(field_id).run_1.spikes.data,1)
            
            cell_id=horzcat('cell_',num2str(p));
        
            spikecount(1,p)=size(find(Data.(field_id).run_1.spikes.data(p).times>time_index_start & Data.(field_id).run_1.spikes.data(p).times<=time_index_end),2);
            Result.(field_id).(run_id).(fixation_id).(cell_id).spikecount=spikecount(1,p);
            Result.(field_id).(run_id).(fixation_id).(cell_id).uuid=Data.(field_id).run_1.spikes.data(p).uuid;
            Result.(field_id).(run_id).(fixation_id).(cell_id).region=Data.(field_id).run_1.spikes.data(p).region;
            clear cell_id
        
        end
        
        clear p fixation_id start_index end_index time_index_start time_index_end duration spikecount 
       
        end
        
        Result.(field_id).(run_id).mean_distance_m1=mean_distance_m1;
        Result.(field_id).(run_id).mean_distance_m2=mean_distance_m2;
        Result.(field_id).(run_id).distance_m1m2=distance_m1m2;
        Result.(field_id).(run_id).x_m1_mean=x_m1_mean;
        Result.(field_id).(run_id).y_m1_mean=y_m1_mean;
        Result.(field_id).(run_id).x_m2_mean=x_m2_mean;
        Result.(field_id).(run_id).y_m2_mean=y_m2_mean;
        Result.(field_id).(run_id).m2_percentage=m2_percentage;
        Result.(field_id).(run_id).control_distance_m1=control_distance_m1;
        Result.(field_id).(run_id).control_distance_m2=control_distance_m2;
        Result.(field_id).(run_id).control_obj_right=control_obj_right;
        Result.(field_id).(run_id).duration=fixation_duration;
        
        
        clear mean_distance_m1 mean_distance_m2 distance_m1m2 x_m1_mean y_m1_mean x_m2_mean y_m2_mean control_distance_m1 control_distance_m2 fixation_duration control_obj_right  m2_percentage
        clear i run_id
        clear Offsets_m1 Offsets_m2 Offsets_m2_m1
        clear roi_m1 roi_m2 center_roi_m1 center_roi_m2 x_m1 x_m2 y_m1 y_m2
        clear fixation_index idcs bin_length max_fixation_length mean_fixation_length median_fixation_length
        
    end 
    
    clear field_id field_run 
    
end

save('Result.mat','Result','-v7.3')

%% Re-organize data

fieldname=fieldnames(Result);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    field_run=fieldnames(Result.(field_id));
   
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        num_cell=size(fieldnames(Result.(field_id).(run_id).fixation_1),1);
        
        for p=1:num_cell
            
            cell_id=horzcat('cell_',num2str(p));
            Spike.(field_id).(run_id).(cell_id).spikecnt=[];
            
            for q=1:size(fieldnames(Result.(field_id).(run_id)),1)-12
                
                fixation_id=horzcat('fixation_',num2str(q));
                
                Spike.(field_id).(run_id).(cell_id).spikecnt=horzcat(Spike.(field_id).(run_id).(cell_id).spikecnt,Result.(field_id).(run_id).(fixation_id).(cell_id).spikecount);
                Spike.(field_id).(run_id).(cell_id).uuid=Result.(field_id).(run_id).fixation_1.(cell_id).uuid;
                Spike.(field_id).(run_id).(cell_id).region=Result.(field_id).(run_id).fixation_1.(cell_id).region;
                
                Spike.(field_id).(run_id).(cell_id).duration=Result.(field_id).(run_id).duration;
                Spike.(field_id).(run_id).(cell_id).mean_distance_m1=Result.(field_id).(run_id).mean_distance_m1;
                Spike.(field_id).(run_id).(cell_id).mean_distance_m2=Result.(field_id).(run_id).mean_distance_m2;
                Spike.(field_id).(run_id).(cell_id).distance_m1m2=Result.(field_id).(run_id).distance_m1m2;
                Spike.(field_id).(run_id).(cell_id).x_m1_mean=Result.(field_id).(run_id).x_m1_mean;
                Spike.(field_id).(run_id).(cell_id).y_m1_mean=Result.(field_id).(run_id).y_m1_mean;
                Spike.(field_id).(run_id).(cell_id).x_m2_mean=Result.(field_id).(run_id).x_m2_mean;
                Spike.(field_id).(run_id).(cell_id).y_m2_mean=Result.(field_id).(run_id).y_m2_mean;
                Spike.(field_id).(run_id).(cell_id).control_distance_m1=Result.(field_id).(run_id).control_distance_m1;
                Spike.(field_id).(run_id).(cell_id).control_distance_m2=Result.(field_id).(run_id).control_distance_m2;
                Spike.(field_id).(run_id).(cell_id).control_obj_right=Result.(field_id).(run_id).control_obj_right;
                Spike.(field_id).(run_id).(cell_id).m2_percentage=Result.(field_id).(run_id).m2_percentage;
                
                clear fixation_id
            end
            clear q cell_id
        end
        clear p run_id num_cell
    end
    clear l field_id field_run
end

save('spike_distance.mat','Spike');            

%% Apply criteria for m1's and m2's fixations

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

ROI='eyes_nf';

fieldname=fieldnames(Spike);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    field_run=fieldnames(Spike.(field_id));
   
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        cell_field=fieldnames(Spike.(field_id).(run_id));
        num_cell=size(cell_field,1);
        
        for p=1:num_cell
            
            cell_id=char(cell_field(p));
            
            for q=1:size(Spike.(field_id).(run_id).(cell_id).spikecnt,2)
                
                if Spike.(field_id).(run_id).(cell_id).mean_distance_m1(1,q)>20*px_per_deg || Spike.(field_id).(run_id).(cell_id).mean_distance_m2(1,q)>20*px_per_deg || Spike.(field_id).(run_id).(cell_id).m2_percentage(1,q)<0.9
                    
                   Spike.(field_id).(run_id).(cell_id).duration(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).mean_distance_m1(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).mean_distance_m2(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).distance_m1m2(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).control_distance_m1(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).control_distance_m2(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).m2_percentage(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).control_obj_right(1,q)=NaN;
                   Spike.(field_id).(run_id).(cell_id).spikecnt(1,q)=NaN;
                   
                end
                 
            end
            
            clear q cell_id
        end
        
        clear p num_cell cell_field center_roi_m1 center_roi_m2 radius_px inter_eye_distance_px roi_m1 roi_m2 
        clear run_id Offsets_m1 Offsets_m2 Offsets_m2_m1
       
    end
    clear l field_id field_run
end
    
save('spike_final.mat','Spike');
         
%% collapse across runs for each cell

fieldname=fieldnames(Spike);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    field_run=fieldnames(Spike.(field_id));
    
    for l=1:size(fieldnames(Spike.(field_id).run_1),1)
        
        cell_run=fieldnames(Spike.(field_id).run_1);
       
        cell_id=char(cell_run(l));
        
       Data.(field_id).(cell_id).spikecnt=[];
       Data.(field_id).(cell_id).duration=[];
       Data.(field_id).(cell_id).uuid=Spike.(field_id).run_1.(cell_id).uuid;
       Data.(field_id).(cell_id).region=Spike.(field_id).run_1.(cell_id).region;
       Data.(field_id).(cell_id).mean_distance_m1=[];
       Data.(field_id).(cell_id).mean_distance_m2=[];
       Data.(field_id).(cell_id).control_distance_m1=[];
       Data.(field_id).(cell_id).control_distance_m2=[];
       Data.(field_id).(cell_id).control_obj_right=[];
       Data.(field_id).(cell_id).distance_m1m2=[];    
       Data.(field_id).(cell_id).x_m1_mean=[];
       Data.(field_id).(cell_id).y_m1_mean=[];
       Data.(field_id).(cell_id).x_m2_mean=[];
       Data.(field_id).(cell_id).y_m2_mean=[];
       Data.(field_id).(cell_id).m2_percentage=[];
       
       
       for m=1:size(field_run,1)
           
       run_id=char(field_run(m));
                  
       Data.(field_id).(cell_id).spikecnt=horzcat(Data.(field_id).(cell_id).spikecnt,Spike.(field_id).(run_id).(cell_id).spikecnt);
       Data.(field_id).(cell_id).duration=horzcat(Data.(field_id).(cell_id).duration,Spike.(field_id).(run_id).(cell_id).duration);
      
       Data.(field_id).(cell_id).mean_distance_m1=horzcat(Data.(field_id).(cell_id).mean_distance_m1,Spike.(field_id).(run_id).(cell_id).mean_distance_m1);
       Data.(field_id).(cell_id).mean_distance_m2=horzcat(Data.(field_id).(cell_id).mean_distance_m2,Spike.(field_id).(run_id).(cell_id).mean_distance_m2);
       Data.(field_id).(cell_id).distance_m1m2=horzcat(Data.(field_id).(cell_id).distance_m1m2,Spike.(field_id).(run_id).(cell_id).distance_m1m2);  
       Data.(field_id).(cell_id).control_distance_m1=horzcat(Data.(field_id).(cell_id).control_distance_m1,Spike.(field_id).(run_id).(cell_id).control_distance_m1);
       Data.(field_id).(cell_id).control_distance_m2=horzcat(Data.(field_id).(cell_id).control_distance_m2,Spike.(field_id).(run_id).(cell_id).control_distance_m2);
       Data.(field_id).(cell_id).control_obj_right=horzcat(Data.(field_id).(cell_id).control_obj_right,Spike.(field_id).(run_id).(cell_id).control_obj_right);
       Data.(field_id).(cell_id).m2_percentage=horzcat(Data.(field_id).(cell_id).m2_percentage, Spike.(field_id).(run_id).(cell_id).m2_percentage);
       
       Data.(field_id).(cell_id).x_m1_mean=horzcat(Data.(field_id).(cell_id).x_m1_mean,Spike.(field_id).(run_id).(cell_id).x_m1_mean);
       Data.(field_id).(cell_id).y_m1_mean=horzcat(Data.(field_id).(cell_id).y_m1_mean,Spike.(field_id).(run_id).(cell_id).y_m1_mean);
       Data.(field_id).(cell_id).x_m2_mean=horzcat(Data.(field_id).(cell_id).x_m2_mean,Spike.(field_id).(run_id).(cell_id).x_m2_mean);
       Data.(field_id).(cell_id).y_m2_mean=horzcat(Data.(field_id).(cell_id).y_m2_mean,Spike.(field_id).(run_id).(cell_id).y_m2_mean);
            
       clear run_id
       end
       
       clear m cell_run cell_id
       
    end
    
    clear l field_run field_id
    
end

       
save('cell_data.mat','Data','-v7.3');      
               
%% Get rid of NaNs

fieldname=fieldnames(Data);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    
    cell_name=fieldnames(Data.(field_id));
        
    for l=1:length(cell_name)
        
       cell_id=char(cell_name(l));
        
       Model.(field_id).(cell_id).uuid=Data.(field_id).(cell_id).uuid;
       Model.(field_id).(cell_id).region=Data.(field_id).(cell_id).region;
       
       Model.(field_id).(cell_id).spikecnt=[];
       Model.(field_id).(cell_id).duration=[];
       
       Model.(field_id).(cell_id).mean_distance_m1=[];
       Model.(field_id).(cell_id).mean_distance_m2=[];
       Model.(field_id).(cell_id).distance_m1m2=[];  
       Model.(field_id).(cell_id).control_obj_right=[];
       Model.(field_id).(cell_id).m2_percentage=[];
       
       for m=1:length(Data.(field_id).(cell_id).spikecnt)
           
           if ~isnan(Data.(field_id).(cell_id).spikecnt(1,m)) && ~isnan(Data.(field_id).(cell_id).duration(1,m)) && ~isnan(Data.(field_id).(cell_id).mean_distance_m1(1,m)) && ~isnan(Data.(field_id).(cell_id).mean_distance_m2(1,m))   

               Model.(field_id).(cell_id).spikecnt=horzcat(Model.(field_id).(cell_id).spikecnt,Data.(field_id).(cell_id).spikecnt(1,m));
               Model.(field_id).(cell_id).duration=horzcat(Model.(field_id).(cell_id).duration,Data.(field_id).(cell_id).duration(1,m));
               Model.(field_id).(cell_id).mean_distance_m1=horzcat(Model.(field_id).(cell_id).mean_distance_m1,Data.(field_id).(cell_id).mean_distance_m1(1,m));
               Model.(field_id).(cell_id).mean_distance_m2=horzcat(Model.(field_id).(cell_id).mean_distance_m2,Data.(field_id).(cell_id).mean_distance_m2(1,m));
               Model.(field_id).(cell_id).distance_m1m2=horzcat(Model.(field_id).(cell_id).distance_m1m2,Data.(field_id).(cell_id).distance_m1m2(1,m));
               Model.(field_id).(cell_id).control_obj_right=horzcat(Model.(field_id).(cell_id).control_obj_right,Data.(field_id).(cell_id).control_obj_right(1,m));
               Model.(field_id).(cell_id).m2_percentage=horzcat(Model.(field_id).(cell_id).m2_percentage,Data.(field_id).(cell_id).m2_percentage(1,m));

           end
       end
       
       clear m cell_id
                  
    end
    clear l field_id
    
end

save('Model_Data.mat','Model');  

%% Fit Stepwise GLM (m1dis + m2dis)

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

fieldname=fieldnames(Model);

for i=1:size(fieldname,1)
    field_id=char(fieldname(i));
    fieldnamecell=fieldnames(Model.(field_id)); 
    
    for j=1:size(fieldnamecell,1)
         cell_id=char(fieldnamecell(j));
         
         % Model Stepwise: spike count on m1 distance and m2 distance
         Stepwise.(field_id).(cell_id).mdl=stepwiseglm(horzcat((Model.(field_id).(cell_id).mean_distance_m1')*deg_per_px,(Model.(field_id).(cell_id).mean_distance_m2')*deg_per_px), Model.(field_id).(cell_id).spikecnt', 'constant','Lower','linear','Upper','linear','Link','log','Distribution' ,'poisson','Offset',(log(Model.(field_id).(cell_id).duration/1000))');
         Stepwise.(field_id).(cell_id).uuid=Model.(field_id).(cell_id).uuid;
         Stepwise.(field_id).(cell_id).region=Model.(field_id).(cell_id).region;
        
         clear cell_id
    end
    
    clear j field_id fieldnamecell 
end

save('Stepwise_Model.mat','Stepwise');

%% Put info together 

% Stepwise

fieldname=fieldnames(Stepwise);
nrow=1;

for i=1:size(fieldname,1)
    field_id=char(fieldname(i));
    fieldnamecell=fieldnames(Stepwise.(field_id));
  
    for j=1:size(fieldnamecell,1)
        cell_id=char(fieldnamecell(j));
         
        BigTable_Stepwise_term{nrow,1}=Stepwise.(field_id).(cell_id).uuid;
        BigTable_Stepwise_term{nrow,2}=Stepwise.(field_id).(cell_id).region;
        BigTable_Stepwise_term{nrow,3}=Stepwise.(field_id).(cell_id).mdl.Rsquared.Adjusted;
        
        BigTable_Stepwise_coef{nrow,1}=Stepwise.(field_id).(cell_id).uuid;
        BigTable_Stepwise_coef{nrow,2}=Stepwise.(field_id).(cell_id).region;
        BigTable_Stepwise_coef{nrow,3}=Stepwise.(field_id).(cell_id).mdl.Rsquared.Adjusted;
        
        BigTable_Stepwise_p{nrow,1}=Stepwise.(field_id).(cell_id).uuid;
        BigTable_Stepwise_p{nrow,2}=Stepwise.(field_id).(cell_id).region;
        BigTable_Stepwise_p{nrow,3}=Stepwise.(field_id).(cell_id).mdl.Rsquared.Adjusted;
        
        BigTable_Stepwise_correlation{nrow,1}=Stepwise.(field_id).(cell_id).uuid;
        BigTable_Stepwise_correlation{nrow,2}=Stepwise.(field_id).(cell_id).region;
        BigTable_Stepwise_correlation{nrow,3}=Stepwise.(field_id).(cell_id).mdl.Rsquared.Adjusted;
        
        range=0:2:20;
    
        for window=1:length(range)-1
        
        index_m1dis=find(Stepwise.(field_id).(cell_id).mdl.Variables.x1 >= range(window) & Stepwise.(field_id).(cell_id).mdl.Variables.x1 < range(window+1));
        m1_m1dis(1,window)=median(Stepwise.(field_id).(cell_id).mdl.Variables.x1(index_m1dis));
        m1_m2dis(1,window)=median(Stepwise.(field_id).(cell_id).mdl.Variables.x2(index_m1dis));
        
        clear index_m1dis 
        
        end
    
        [r_m1dis_m2dis,p_m1dis_m2dis]=corr(m1_m1dis',m1_m2dis','Type','Spearman');
        BigTable_Stepwise_correlation{nrow,4}=r_m1dis_m2dis;
        BigTable_Stepwise_correlation{nrow,5}=p_m1dis_m2dis;
       
        clear m1_m1dis m1_m2dis r_m1dis_m2dis p_m1dis_m2dis
     
        term_size=size(Stepwise.(field_id).(cell_id).mdl.Steps.History,1);
        
        for k=1:term_size
            
            BigTable_Stepwise_term{nrow,3+k}=Stepwise.(field_id).(cell_id).mdl.Steps.History{k,2};
            
            if k==1
                
            BigTable_Stepwise_coef{nrow,3+k}=Stepwise.(field_id).(cell_id).mdl.Coefficients{'(Intercept)',1};
            BigTable_Stepwise_p{nrow,3+k}=Stepwise.(field_id).(cell_id).mdl.Coefficients{'(Intercept)',4};
            
            else
                
            BigTable_Stepwise_coef{nrow,3+k}=Stepwise.(field_id).(cell_id).mdl.Coefficients{cell2mat(BigTable_Stepwise_term{nrow,3+k}),1};
            BigTable_Stepwise_p{nrow,3+k}=Stepwise.(field_id).(cell_id).mdl.Coefficients{cell2mat(BigTable_Stepwise_term{nrow,3+k}),4};
            
            end
            
        end
        
        nrow=nrow+1;
        
        clear term_size cell_id
    end
    
    clear j field_id fieldnamecell
end

save('BigTable_Stepwise_term.mat','BigTable_Stepwise_term');
save('BigTable_Stepwise_coefo.mat','BigTable_Stepwise_coef');
save('BigTable_Stepwise_p.mat','BigTable_Stepwise_p');
save('BigTable_Stepwise_correlation.mat','BigTable_Stepwise_correlation');

%% Fit Stepwise GLM for null distribution (100 times)

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

fieldname=fieldnames(Model);

for i=1:size(fieldname,1)
    field_id=char(fieldname(i));
    fieldnamecell=fieldnames(Model.(field_id));
    
    for j=1:size(fieldnamecell,1)
         cell_id=char(fieldnamecell(j));
       
         Stepwise.(field_id).(cell_id).uuid=Model.(field_id).(cell_id).uuid;
         Stepwise.(field_id).(cell_id).region=Model.(field_id).(cell_id).region;
         
         for rep=1:100
         shuffle_index=randperm(length(Model.(field_id).(cell_id).mean_distance_m1),length(Model.(field_id).(cell_id).mean_distance_m1));
         
         % Model Stepwise: spike count on m1 distance and m2 distance
         model_null=stepwiseglm(horzcat((Model.(field_id).(cell_id).mean_distance_m1(shuffle_index)')*deg_per_px,(Model.(field_id).(cell_id).mean_distance_m2(shuffle_index)')*deg_per_px), Model.(field_id).(cell_id).spikecnt','constant','Lower','linear','Upper','linear','Link','log','Distribution' ,'poisson','Offset',(log(Model.(field_id).(cell_id).duration/1000))');
         Stepwise.(field_id).(cell_id).R2(1,rep)=model_null.Rsquared.Adjusted;
         
         clear model_null shuffle_index
         
         end
        
         clear cell_id m1dis m2dis m1m2dis spikecnt
    end
    
    clear j field_id fieldnamecell 
end

save('Stepwise_Model_Null.mat','Stepwise','-v7.3');

%% Put info together (Null)

fieldname=fieldnames(Stepwise);
nrow=1;

for i=1:size(fieldname,1)
    field_id=char(fieldname(i));
    fieldnamecell=fieldnames(Stepwise.(field_id));
  
    for j=1:size(fieldnamecell,1)
        cell_id=char(fieldnamecell(j));
        
        BigTable_R2_null{nrow,1}=Stepwise.(field_id).(cell_id).uuid;
        BigTable_R2_null{nrow,2}=Stepwise.(field_id).(cell_id).region;
        
        for k=1:100
            
        BigTable_R2_null{nrow,k+2}=Stepwise.(field_id).(cell_id).R2(1,k);
        
        end
        
        nrow=nrow+1;
        
        clear term_size cell_id clear k
    end
    
    clear j field_id fieldnamecell
end

save('BigTable_R2_Null.mat','BigTable_R2_null');
