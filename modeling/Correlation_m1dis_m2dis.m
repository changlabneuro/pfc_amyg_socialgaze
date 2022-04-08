%% Correlation between variables (binned data)

% upload Model

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

fieldname=fieldnames(Model);

for i=1:size(fieldname,1)
    field_id=char(fieldname(i));
    
    range=0:2:20;
    
    for j=1:length(range)-1
        
        index_m1dis=find(Model.(field_id).cell_1.mean_distance_m1*deg_per_px >= range(j) & Model.(field_id).cell_1.mean_distance_m1*deg_per_px < range(j+1));
        m1_m1dis(i,j)=median(Model.(field_id).cell_1.mean_distance_m1(index_m1dis))*deg_per_px;
        m1_m2dis(i,j)=median(Model.(field_id).cell_1.mean_distance_m2(index_m1dis))*deg_per_px;
 
        clear index_m1dis 
        
    end
    
    [r_m1dis_m2dis(i),p_m1dis_m2dis(i)]=corr(m1_m1dis(i,:)'*deg_per_px,m1_m2dis(i,:)'*deg_per_px,'Type','Spearman');
     
end

BinCorr.m1dis_m2dis.p=[Kuro_p_m1dis_m2dis Lynch_p_m1dis_m2dis];

save('Binned_Correlation.mat','BinCorr');
save('Behavior_Correlation.mat','BehaviorCorr');

%% Plot correlation using binned data
    
nday=length(BehaviorCorr.m1_m1dis);

subplot(1,3,1)
for day=1:nday
    scatter(BehaviorCorr.m1_m1dis(day,:),BehaviorCorr.m1_m2dis(day,:),15,'filled','k'); hold on
end
title('m1dis vs. m2dis');
xlim([0 20]);
ylim([0 20]);
axis square
    
subplot(1,3,2) % m1dis_m2dis r
histogram(BinCorr.m1dis_m2dis.r,0:0.05:1); hold on
plot([median(BinCorr.m1dis_m2dis.r) median(BinCorr.m1dis_m2dis.r)],[0 15]); hold on
xlim([-0.1 1.1]);
ylim([0 10]);
xticks([-0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1]);
title('m1dis vs. m2dis: R')
axis square

subplot(1,3,3) % m1dis_m2dis p
bar([sum(BinCorr.m1dis_m2dis.p<0.05)/nday sum(BinCorr.m1dis_m2dis.p>=0.05)/nday]); hold on
ylim([0 1]);
title('m1dis vs. m2dis: p')
axis square

sgtitle('Correlation between m1dis and m2dis (binned)')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('Correlation_behavior'));
saveas(gcf,sprintf('Correlation_behavior.png'));
saveas(gcf,sprintf('Correlation_behavior.epsc'));

%% Additional plotting

Colors=colormap(jet(length(BehaviorCorr.m1_m1dis)));
nday=length(BehaviorCorr.m1_m1dis);
m1_m1dis=[];
m1_m2dis=[];


subplot(1,2,1)
for day=1:nday
    scatter(BehaviorCorr.m1_m1dis(day,:),BehaviorCorr.m1_m2dis(day,:),15,'filled','MarkerFaceColor',Colors(day,:)); hold on
    m1_m1dis=horzcat(m1_m1dis,BehaviorCorr.m1_m1dis(day,:));
    m1_m2dis=horzcat(m1_m2dis,BehaviorCorr.m1_m2dis(day,:));
end
[r_m1dis_m2dis,p_m1dis_m2dis]=corr(m1_m1dis',m1_m2dis','Type','Spearman');  
title(sprintf(['m1dis vs. m2dis: r = ' num2str(r_m1dis_m2dis) '; p= ' num2str(p_m1dis_m2dis)]));
xlim([0 20]);
ylim([0 20]);
axis square

subplot(1,2,2) % m1dis_m2dis p
histogram(BinCorr.m1dis_m2dis.p,0:0.05:1); hold on
xlim([-0.1 1.1]);
ylim([0 20]);
xticks([-0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1]);
title('m1dis vs. m2dis: p')
axis square

sgtitle('Correlation between m1dis and m2dis additional (binned)')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('Correlation_behavior_additional'));
saveas(gcf,sprintf('Correlation_behavior_additional.png'));
saveas(gcf,sprintf('Correlation_behavior_additional.epsc'));
