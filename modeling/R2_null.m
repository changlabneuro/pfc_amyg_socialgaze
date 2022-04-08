%% Put R2 from stepwise and null together

% OFC 

for i=1:length(OFC_index)
   
       OFC_R2(i,1)=BigTable_Stepwise_term{OFC_index(i),3};
       
       for j=3:102
           
           OFC_R2(i,j-1)=BigTable_R2_null{OFC_index(i),j};
           
       end
       
end

% dmPFC 

for i=1:length(dmPFC_index)
   
       dmPFC_R2(i,1)=BigTable_Stepwise_term{dmPFC_index(i),3};
       
       for j=3:102
           
           dmPFC_R2(i,j-1)=BigTable_R2_null{dmPFC_index(i),j};
           
       end
       
end

% ACCg 

for i=1:length(ACCg_index)
   
       ACCg_R2(i,1)=BigTable_Stepwise_term{ACCg_index(i),3};
       
       for j=3:102
           
           ACCg_R2(i,j-1)=BigTable_R2_null{ACCg_index(i),j};
           
       end
       
end



% BLA

for i=1:length(BLA_index)
   
       BLA_R2(i,1)=BigTable_Stepwise_term{BLA_index(i),3};
       
       for j=3:102
           
           BLA_R2(i,j-1)=BigTable_R2_null{BLA_index(i),j};
           
       end
       
end

%% Calculate p value

OFC_R2_mean=mean(OFC_R2,1);
OFC_p=sum(OFC_R2_mean(2:101)>=OFC_R2_mean(1,1));

dmPFC_R2_mean=mean(dmPFC_R2,1);
dmPFC_p=sum(dmPFC_R2_mean(2:101)>=dmPFC_R2_mean(1,1));

ACCg_R2_mean=mean(ACCg_R2,1);
ACCg_p=sum(ACCg_R2_mean(2:101)>=ACCg_R2_mean(1,1));

BLA_R2_mean=mean(BLA_R2,1);
BLA_p=sum(BLA_R2_mean(2:101)>=BLA_R2_mean(1,1));

OFC_R2_median=median(OFC_R2,1);
OFC_p_2=sum(OFC_R2_median(2:101)>=OFC_R2_median(1,1));

dmPFC_R2_median=median(dmPFC_R2,1);
dmPFC_p_2=sum(dmPFC_R2_median(2:101)>=dmPFC_R2_median(1,1));

ACCg_R2_median=median(ACCg_R2,1);
ACCg_p_2=sum(ACCg_R2_median(2:101)>=ACCg_R2_median(1,1));

BLA_R2_median=median(BLA_R2,1);
BLA_p_2=sum(BLA_R2_median(2:101)>=BLA_R2_median(1,1));

Violin_data{1,1}=OFC_R2(:,1);
Violin_data{1,2}=dmPFC_R2(:,1);
Violin_data{1,3}=ACCg_R2(:,1);
Violin_data{1,4}=BLA_R2(:,1);

violin(Violin_data);
ylim([-0.4 1]); hold on
yticks([-0.4 -0.2 0 0.2 0.4 0.6 0.8 1]); hold on
set(gca,'TickLength',[0.01 0.01]); hold on

% OFC

for j=2:101
    
    scatter(1,OFC_R2_mean(1,j),30,'k'); hold on
    scatter(1,OFC_R2_median(1,j),30,'r'); hold on
    
end

% dmPFC

for l=2:101
    
    scatter(2,dmPFC_R2_mean(1,l),30,'k'); hold on
    scatter(2,dmPFC_R2_median(1,l),30,'r'); hold on
    
end

% ACCg

for k=2:101
    
    scatter(3,ACCg_R2_mean(1,k),30,'k'); hold on
    scatter(3,ACCg_R2_median(1,k),30,'r'); hold on
end


% BLA

for i=2:101
    
    scatter(4,BLA_R2_mean(1,i),30,'k'); hold on
    scatter(4,BLA_R2_median(1,i),30,'r'); hold on
end

sgtitle('Distribution of adjusted R2 of all neurons (compared to null)')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('R2_violin_null'));
saveas(gcf,sprintf('R2_violin_null.png'));
saveas(gcf,sprintf('R2_violin_null.epsc'));

BLA_length=length(BLA_R2);
BigTable_R2(1,1:BLA_length)=BLA_R2(:,1);
for i=1:BLA_length
BigTable_label(1,i)=string('BLA');
end

OFC_length=length(OFC_R2);
BigTable_R2(1,BLA_length+1:BLA_length+OFC_length)=OFC_R2(:,1);
for j=BLA_length+1:BLA_length+OFC_length
BigTable_label(1,j)=string('OFC');
end

ACCg_length=length(ACCg_R2);
BigTable_R2(1,BLA_length+OFC_length+1:BLA_length+OFC_length+ACCg_length)=ACCg_R2(:,1);
for k=BLA_length+OFC_length+1:BLA_length+OFC_length+ACCg_length
BigTable_label(1,k)=string('ACCg');
end

dmPFC_length=length(dmPFC_R2);
BigTable_R2(1,BLA_length+OFC_length+ACCg_length+1:BLA_length+OFC_length+ACCg_length+dmPFC_length)=dmPFC_R2(:,1);
for l=BLA_length+OFC_length+ACCg_length+1:BLA_length+OFC_length+ACCg_length+dmPFC_length
BigTable_label(1,l)=string('dmPFC');
end

[p,tbl,stats]=anova1(BigTable_R2,BigTable_label);
[c, m, h, gnames]=multcompare(stats);
