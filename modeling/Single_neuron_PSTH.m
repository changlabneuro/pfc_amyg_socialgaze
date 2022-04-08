%% Plotting PSTHs based on 4 distance

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

fieldname=fieldnames(PSTH_spike);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(PSTH_spike.(field_id));
    
     for l=1:size(field_run,1)
           
       cell_id=char(field_run(l));
       
       PSTH_model.(field_id).(cell_id).mean_distance_m1_group1=find(PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px>=0 & PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px<5);
       PSTH_model.(field_id).(cell_id).mean_distance_m1_group2=find(PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px>=5 & PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px<10);
       PSTH_model.(field_id).(cell_id).mean_distance_m1_group3=find(PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px>=10 & PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px<15);
       PSTH_model.(field_id).(cell_id).mean_distance_m1_group4=find(PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px>=15 & PSTH_behavior_model.(field_id).mean_distance_m1*deg_per_px<20);
       
       PSTH_model.(field_id).(cell_id).mean_distance_m2_group1=find(PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px>=0 & PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px<5);
       PSTH_model.(field_id).(cell_id).mean_distance_m2_group2=find(PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px>=5 & PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px<10);
       PSTH_model.(field_id).(cell_id).mean_distance_m2_group3=find(PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px>=10 & PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px<15);
       PSTH_model.(field_id).(cell_id).mean_distance_m2_group4=find(PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px>=15 & PSTH_behavior_model.(field_id).mean_distance_m2*deg_per_px<20);
       
       PSTH_model.(field_id).(cell_id).spike=PSTH_spike.(field_id).(cell_id).spike;
       PSTH_model.(field_id).(cell_id).uuid=PSTH_spike.(field_id).(cell_id).uuid;
       PSTH_model.(field_id).(cell_id).region=PSTH_spike.(field_id).(cell_id).region;
       PSTH_model.(field_id).(cell_id).event_start_time=PSTH_behavior_model.(field_id).event_start_time;
       
       % plotting PSTHs
       
        bin_size = 1e-2;  % 10ms
        min_t = -0.1;
        max_t = 0.4;
        smooth_trace = true;
        
        event_times_m1_group1 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m1_group1)';
        event_times_m1_group2 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m1_group2)';
        event_times_m1_group3 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m1_group3)';
        event_times_m1_group4 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m1_group4)';
        
        event_times_m2_group1 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m2_group1)';
        event_times_m2_group2 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m2_group2)';
        event_times_m2_group3 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m2_group3)';
        event_times_m2_group4 = PSTH_model.(field_id).(cell_id).event_start_time(PSTH_model.(field_id).(cell_id).mean_distance_m2_group4)';
        
        spike_times = PSTH_model.(field_id).(cell_id).spike';
        
        [spikes_m1_group1, t_m1_group1] = bfw.trial_psth( spike_times, event_times_m1_group1, min_t, max_t, bin_size );
        [spikes_m1_group2, t_m1_group2] = bfw.trial_psth( spike_times, event_times_m1_group2, min_t, max_t, bin_size );
        [spikes_m1_group3, t_m1_group3] = bfw.trial_psth( spike_times, event_times_m1_group3, min_t, max_t, bin_size );
        [spikes_m1_group4, t_m1_group4] = bfw.trial_psth( spike_times, event_times_m1_group4, min_t, max_t, bin_size );
        
        [spikes_m2_group1, t_m2_group1] = bfw.trial_psth( spike_times, event_times_m2_group1, min_t, max_t, bin_size );
        [spikes_m2_group2, t_m2_group2] = bfw.trial_psth( spike_times, event_times_m2_group2, min_t, max_t, bin_size );
        [spikes_m2_group3, t_m2_group3] = bfw.trial_psth( spike_times, event_times_m2_group3, min_t, max_t, bin_size );
        [spikes_m2_group4, t_m2_group4] = bfw.trial_psth( spike_times, event_times_m2_group4, min_t, max_t, bin_size );
        
        % m1dis PSTHs
        
        subplot(1,4,1)
        m1_colormap=colormap(winter(10));
        
        if ( smooth_trace )
          for i = 1:size(spikes_m1_group1, 1)
            spikes_m1_group1(i, :) = movmean( spikes_m1_group1(i, :), 10 );
          end
        end
        spikes_m1_group1 = spikes_m1_group1 / bin_size;
        plot( t_m1_group1, mean(spikes_m1_group1, 1), 'Color', m1_colormap(1,:)); hold on
        clear i
        
        if ( smooth_trace )
          for i = 1:size(spikes_m1_group2, 1)
            spikes_m1_group2(i, :) = movmean( spikes_m1_group2(i, :), 10 );
          end
        end
        spikes_m1_group2 = spikes_m1_group2 / bin_size;
        plot( t_m1_group2, mean(spikes_m1_group2, 1), 'Color', m1_colormap(4,:)); hold on
        clear i
        
        if ( smooth_trace )
          for i = 1:size(spikes_m1_group3, 1)
            spikes_m1_group3(i, :) = movmean( spikes_m1_group3(i, :), 10 );
          end
        end
        spikes_m1_group3 = spikes_m1_group3 / bin_size;
        plot( t_m1_group3, mean(spikes_m1_group3, 1), 'Color', m1_colormap(7,:)); hold on
        clear i
        
        if ( smooth_trace )
          for i = 1:size(spikes_m1_group4, 1)
            spikes_m1_group4(i, :) = movmean( spikes_m1_group4(i, :), 10 );
          end
        end
        spikes_m1_group4 = spikes_m1_group4 / bin_size; 
        plot( t_m1_group4, mean(spikes_m1_group4, 1), 'Color', m1_colormap(10,:)); hold on
        plot([0 0], [(min([mean(spikes_m1_group1, 1) mean(spikes_m1_group2, 1) mean(spikes_m1_group3, 1) mean(spikes_m1_group4, 1)])-1) (max([mean(spikes_m1_group1, 1) mean(spikes_m1_group2, 1) mean(spikes_m1_group3, 1) mean(spikes_m1_group4, 1)])+1)],'k'); hold on
        xticks([-0.1 0 0.1 0.2 0.3 0.4]); hold on
        clear i
        
        title('distance m1'); hold on
        legend; hold on
        
        % m2dis PSTHs
        subplot(1,4,3)
        m2_colormap=colormap(cool(10));
        
        if ( smooth_trace )
          for i = 1:size(spikes_m2_group1, 1)
            spikes_m2_group1(i, :) = movmean( spikes_m2_group1(i, :), 10 );
          end
        end
        spikes_m2_group1 = spikes_m2_group1 / bin_size;
        plot( t_m2_group1, mean(spikes_m2_group1, 1), 'Color', m2_colormap(1,:)); hold on
        clear i
        
        if ( smooth_trace )
          for i = 1:size(spikes_m2_group2, 1)
            spikes_m2_group2(i, :) = movmean( spikes_m2_group2(i, :), 10 );
          end
        end
        spikes_m2_group2 = spikes_m2_group2 / bin_size;
        plot( t_m2_group2, mean(spikes_m2_group2, 1), 'Color', m2_colormap(4,:)); hold on
        clear i
        
        if ( smooth_trace )
          for i = 1:size(spikes_m2_group3, 1)
            spikes_m2_group3(i, :) = movmean( spikes_m2_group3(i, :), 10 );
          end
        end
        spikes_m2_group3 = spikes_m2_group3 / bin_size;
        plot( t_m2_group3, mean(spikes_m2_group3, 1), 'Color', m2_colormap(7,:)); hold on
        clear i
        
        if ( smooth_trace )
          for i = 1:size(spikes_m2_group4, 1)
            spikes_m2_group4(i, :) = movmean( spikes_m2_group4(i, :), 10 );
          end
        end
        spikes_m2_group4 = spikes_m2_group4 / bin_size;
        plot( t_m2_group4, mean(spikes_m2_group4, 1), 'Color', m2_colormap(10,:)); hold on
        plot([0 0], [(min([mean(spikes_m2_group1, 1) mean(spikes_m2_group2, 1) mean(spikes_m2_group3, 1) mean(spikes_m2_group4, 1)])-1) (max([mean(spikes_m2_group1, 1) mean(spikes_m2_group2, 1) mean(spikes_m2_group3, 1) mean(spikes_m2_group4, 1)])+1)],'k'); hold on
        xticks([-0.1 0 0.1 0.2 0.3 0.4]); hold on
        clear i
        
        title('distance m2'); hold on
        legend; hold on
               
        % plotting mean activity within 0-250ms
       
        bin_size_mean = 0.25;
        min_t_mean = 0;
        max_t_mean = 0.25;
        
        [spikes_m1_group1_mean, t_m1_group1_mean] = bfw.trial_psth( spike_times, event_times_m1_group1, min_t_mean, max_t_mean, bin_size_mean );
        [spikes_m1_group2_mean, t_m1_group2_mean] = bfw.trial_psth( spike_times, event_times_m1_group2, min_t_mean, max_t_mean, bin_size_mean );
        [spikes_m1_group3_mean, t_m1_group3_mean] = bfw.trial_psth( spike_times, event_times_m1_group3, min_t_mean, max_t_mean, bin_size_mean );
        [spikes_m1_group4_mean, t_m1_group4_mean] = bfw.trial_psth( spike_times, event_times_m1_group4, min_t_mean, max_t_mean, bin_size_mean );
        
        [spikes_m2_group1_mean, t_m2_group1_mean] = bfw.trial_psth( spike_times, event_times_m2_group1, min_t_mean, max_t_mean, bin_size_mean );
        [spikes_m2_group2_mean, t_m2_group2_mean] = bfw.trial_psth( spike_times, event_times_m2_group2, min_t_mean, max_t_mean, bin_size_mean );
        [spikes_m2_group3_mean, t_m2_group3_mean] = bfw.trial_psth( spike_times, event_times_m2_group3, min_t_mean, max_t_mean, bin_size_mean );
        [spikes_m2_group4_mean, t_m2_group4_mean] = bfw.trial_psth( spike_times, event_times_m2_group4, min_t_mean, max_t_mean, bin_size_mean );
        
        subplot(1,4,2)
        scatter([1 2 3 4], [mean(spikes_m1_group1_mean)/bin_size_mean mean(spikes_m1_group2_mean)/bin_size_mean mean(spikes_m1_group3_mean)/bin_size_mean mean(spikes_m1_group4_mean)/bin_size_mean]);
        xlim([0 5]);
        ylim([min([mean(spikes_m1_group1_mean)/bin_size_mean mean(spikes_m1_group2_mean)/bin_size_mean mean(spikes_m1_group3_mean)/bin_size_mean mean(spikes_m1_group4_mean)/bin_size_mean])-1  max([mean(spikes_m1_group1_mean)/bin_size_mean mean(spikes_m1_group2_mean)/bin_size_mean mean(spikes_m1_group3_mean)/bin_size_mean mean(spikes_m1_group4_mean)/bin_size_mean])+1]);
        title('m1 dis mean');
        hold on
        
        subplot(1,4,4)
        scatter([1 2 3 4], [mean(spikes_m2_group1_mean)/bin_size_mean mean(spikes_m2_group2_mean)/bin_size_mean mean(spikes_m2_group3_mean)/bin_size_mean mean(spikes_m2_group4_mean)/bin_size_mean]);
        xlim([0 5]);
        ylim([min([mean(spikes_m2_group1_mean)/bin_size_mean mean(spikes_m2_group2_mean)/bin_size_mean mean(spikes_m2_group3_mean)/bin_size_mean mean(spikes_m2_group4_mean)/bin_size_mean])-1  max([mean(spikes_m2_group1_mean)/bin_size_mean mean(spikes_m2_group2_mean)/bin_size_mean mean(spikes_m2_group3_mean)/bin_size_mean mean(spikes_m2_group4_mean)/bin_size_mean])+1]);
        title('m2 dis mean');
        hold on
        
        sgtitle(sprintf([PSTH_model.(field_id).(cell_id).region ' ' num2str(PSTH_model.(field_id).(cell_id).uuid)]));
        
        set(gcf, 'Renderer', 'painters');
        saveas(gcf,sprintf(['id_',num2str(PSTH_model.(field_id).(cell_id).uuid),'_',PSTH_model.(field_id).(cell_id).region,'.jpg']))
        saveas(gcf,sprintf(['id_',num2str(PSTH_model.(field_id).(cell_id).uuid),'_',PSTH_model.(field_id).(cell_id).region,'.epsc']))
        saveas(gcf,sprintf(['id_',num2str(PSTH_model.(field_id).(cell_id).uuid),'_',PSTH_model.(field_id).(cell_id).region,'.fig']))
        
        clf
        
        clear cell_id bin_size min_t max_t smooth_trace
        clear event_times_m1_group1 event_times_m1_group2 event_times_m1_group3 event_times_m1_group4 
        clear event_times_m2_group1 event_times_m2_group2 event_times_m2_group3 event_times_m2_group4 
        clear event_times_m1m2_group1 event_times_m1m2_group2 event_times_m1m2_group3 event_times_m1m2_group4 
        clear spike_times
        clear spikes_m1_group1 t_m1_group1 spikes_m1_group2 t_m1_group2 spikes_m1_group3 t_m1_group3 spikes_m1_group4 t_m1_group4
        clear spikes_m2_group1 t_m2_group1 spikes_m2_group2 t_m2_group2 spikes_m2_group3 t_m2_group3 spikes_m2_group4 t_m2_group4
        clear spikes_m1m2_group1 t_m1m2_group1 spikes_m1m2_group2 t_m1m2_group2 spikes_m1m2_group3 t_m1m2_group3 spikes_m1m2_group4 t_m1m2_group4
        clear spikes_m1_group1_mean t_m1_group1_mean spikes_m1_group2_mean t_m1_group2_mean spikes_m1_group3_mean t_m1_group3_mean spikes_m1_group4_mean t_m1_group4_mean
        clear spikes_m2_group1_mean t_m2_group1_mean spikes_m2_group2_mean t_m2_group2_mean spikes_m2_group3_mean t_m2_group3_mean spikes_m2_group4_mean t_m2_group4_mean
     end
     
     clear l field_id field_run
     
end
