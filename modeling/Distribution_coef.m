%% Distribution of the coefficients of the best (better) term

% OFC

OFC_x1_best=[];
OFC_x2_best=[];
OFC_none_best=0;
OFC_all=length(OFC_index);

for i=1:length(OFC_index)
    
    if isempty(BigTable_Stepwise_term{OFC_index(i),5})  
        OFC_none_best=OFC_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x1')        
        OFC_x1_best=[OFC_x1_best BigTable_Stepwise_coef{OFC_index(i),5}];
    elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x2')
        OFC_x2_best=[OFC_x2_best BigTable_Stepwise_coef{OFC_index(i),5}];
    end
    
end

% dmPFC

dmPFC_x1_best=[];
dmPFC_x2_best=[];
dmPFC_none_best=0;
dmPFC_all=length(dmPFC_index);

for i=1:length(dmPFC_index)
    
    if isempty(BigTable_Stepwise_term{dmPFC_index(i),5})  
        dmPFC_none_best=dmPFC_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x1')        
        dmPFC_x1_best=[dmPFC_x1_best BigTable_Stepwise_coef{dmPFC_index(i),5}];
    elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x2')
        dmPFC_x2_best=[dmPFC_x2_best BigTable_Stepwise_coef{dmPFC_index(i),5}];
    end
    
end

% ACCg

ACCg_x1_best=[];
ACCg_x2_best=[];
ACCg_none_best=0;
ACCg_all=length(ACCg_index);

for i=1:length(ACCg_index)
    
    if isempty(BigTable_Stepwise_term{ACCg_index(i),5})  
        ACCg_none_best=ACCg_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x1')        
        ACCg_x1_best=[ACCg_x1_best BigTable_Stepwise_coef{ACCg_index(i),5}];
    elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x2')
        ACCg_x2_best=[ACCg_x2_best BigTable_Stepwise_coef{ACCg_index(i),5}];
    end
    
end

% BLA

BLA_x1_best=[];
BLA_x2_best=[];
BLA_none_best=0;
BLA_all=length(BLA_index);

for i=1:length(BLA_index)
    
    if isempty(BigTable_Stepwise_term{BLA_index(i),5})  
        BLA_none_best=BLA_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x1')        
        BLA_x1_best=[BLA_x1_best BigTable_Stepwise_coef{BLA_index(i),5}];
    elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x2')
        BLA_x2_best=[BLA_x2_best BigTable_Stepwise_coef{BLA_index(i),5}];
    end
    
end

%% Plotting distribution of coefficients

% OFC

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,1)
histogram(OFC_x1_best,x_m1dis);hold on
plot([median(OFC_x1_best) median(OFC_x1_best)], [0 length(OFC_x1_best)*0.35],'r'); hold on
title('OFC M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(OFC_x1_best)*0.35]);
yticks([0 length(OFC_x1_best)*0.05 length(OFC_x1_best)*0.1 length(OFC_x1_best)*0.15 length(OFC_x1_best)*0.2 length(OFC_x1_best)*0.25 length(OFC_x1_best)*0.3 length(OFC_x1_best)*0.35]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,5)
histogram(OFC_x2_best,x_m2dis); hold on
plot([median(OFC_x2_best) median(OFC_x2_best)], [0 length(OFC_x2_best)*0.35],'r'); hold on
title('OFC M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(OFC_x2_best)*0.35]);
yticks([0 length(OFC_x2_best)*0.05 length(OFC_x2_best)*0.1 length(OFC_x2_best)*0.15 length(OFC_x2_best)*0.2 length(OFC_x2_best)*0.25 length(OFC_x2_best)*0.3 length(OFC_x2_best)*0.35]);
axis square;

% dmPFC

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,2)
histogram(dmPFC_x1_best,x_m1dis);hold on
plot([median(dmPFC_x1_best) median(dmPFC_x1_best)], [0 length(dmPFC_x1_best)*0.35],'r'); hold on
title('dmPFC M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(dmPFC_x1_best)*0.35]);
yticks([0 length(dmPFC_x1_best)*0.05 length(dmPFC_x1_best)*0.1 length(dmPFC_x1_best)*0.15 length(dmPFC_x1_best)*0.2 length(dmPFC_x1_best)*0.25 length(dmPFC_x1_best)*0.3 length(dmPFC_x1_best)*0.35]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,6)
histogram(dmPFC_x2_best,x_m2dis); hold on
plot([median(dmPFC_x2_best) median(dmPFC_x2_best)], [0 length(dmPFC_x2_best)*0.35],'r'); hold on
title('dmPFC M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(dmPFC_x2_best)*0.35]);
yticks([0 length(dmPFC_x2_best)*0.05 length(dmPFC_x2_best)*0.1 length(dmPFC_x2_best)*0.15 length(dmPFC_x2_best)*0.2 length(dmPFC_x2_best)*0.25 length(dmPFC_x2_best)*0.3 length(dmPFC_x2_best)*0.35]);
axis square;

% ACCg

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,3)
histogram(ACCg_x1_best,x_m1dis);hold on
plot([median(ACCg_x1_best) median(ACCg_x1_best)], [0 length(ACCg_x1_best)*0.35],'r'); hold on
title('ACCg M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(ACCg_x1_best)*0.35]);
yticks([0 length(ACCg_x1_best)*0.05 length(ACCg_x1_best)*0.1 length(ACCg_x1_best)*0.15 length(ACCg_x1_best)*0.2 length(ACCg_x1_best)*0.25 length(ACCg_x1_best)*0.3 length(ACCg_x1_best)*0.35]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,7)
histogram(ACCg_x2_best,x_m2dis); hold on
plot([median(ACCg_x2_best) median(ACCg_x2_best)], [0 length(ACCg_x2_best)*0.35],'r'); hold on
title('ACCg M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(ACCg_x2_best)*0.35]);
yticks([0 length(ACCg_x2_best)*0.05 length(ACCg_x2_best)*0.1 length(ACCg_x2_best)*0.15 length(ACCg_x2_best)*0.2 length(ACCg_x2_best)*0.25 length(ACCg_x2_best)*0.3 length(ACCg_x2_best)*0.35]);
axis square;

% BLA

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,4)
histogram(BLA_x1_best,x_m1dis);hold on
plot([median(BLA_x1_best) median(BLA_x1_best)], [0 length(BLA_x1_best)*0.35],'r'); hold on
title('BLA M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(BLA_x1_best)*0.35]);
yticks([0 length(BLA_x1_best)*0.05 length(BLA_x1_best)*0.1 length(BLA_x1_best)*0.15 length(BLA_x1_best)*0.2 length(BLA_x1_best)*0.25 length(BLA_x1_best)*0.3 length(BLA_x1_best)*0.35]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,8)
histogram(BLA_x2_best,x_m2dis); hold on
plot([median(BLA_x2_best) median(BLA_x2_best)], [0 length(BLA_x2_best)*0.35],'r'); hold on
title('BLA M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(BLA_x2_best)*0.35]);
yticks([0 length(BLA_x2_best)*0.05 length(BLA_x2_best)*0.1 length(BLA_x2_best)*0.15 length(BLA_x2_best)*0.2 length(BLA_x2_best)*0.25 length(BLA_x2_best)*0.3 length(BLA_x2_best)*0.35]);
axis square;
sgtitle('Distribution of coefficients of the best term')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('Distribution_best_term'));
saveas(gcf,sprintf('Distribution_best_term.png'));
saveas(gcf,sprintf('Distribution_best_term.epsc'));

%% Distribution of the coefficients of significant term

% OFC

OFC_x1=[];
OFC_x2=[];
OFC_none=0;
OFC_all=length(OFC_index);

for i=1:length(OFC_index)
    
    if ~isempty(BigTable_Stepwise_term{OFC_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x1') 
           OFC_x1=[OFC_x1 BigTable_Stepwise_coef{OFC_index(i),5}];
       elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x2')
           OFC_x2=[OFC_x2 BigTable_Stepwise_coef{OFC_index(i),5}];
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{OFC_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),6}),'x1') 
           OFC_x1=[OFC_x1 BigTable_Stepwise_coef{OFC_index(i),6}];
       elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),6}),'x2')
           OFC_x2=[OFC_x2 BigTable_Stepwise_coef{OFC_index(i),6}];
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{OFC_index(i),5}) && isempty(BigTable_Stepwise_term{OFC_index(i),6}) 
        
        OFC_none=OFC_none+1;
        
    end
    
end

% dmPFC

dmPFC_x1=[];
dmPFC_x2=[];
dmPFC_none=0;
dmPFC_all=length(dmPFC_index);

for i=1:length(dmPFC_index)
    
    if ~isempty(BigTable_Stepwise_term{dmPFC_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x1') 
           dmPFC_x1=[dmPFC_x1 BigTable_Stepwise_coef{dmPFC_index(i),5}];
       elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x2')
           dmPFC_x2=[dmPFC_x2 BigTable_Stepwise_coef{dmPFC_index(i),5}];
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{dmPFC_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),6}),'x1') 
           dmPFC_x1=[dmPFC_x1 BigTable_Stepwise_coef{dmPFC_index(i),6}];
       elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),6}),'x2')
           dmPFC_x2=[dmPFC_x2 BigTable_Stepwise_coef{dmPFC_index(i),6}];
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{dmPFC_index(i),5}) && isempty(BigTable_Stepwise_term{dmPFC_index(i),6}) 
        
        dmPFC_none=dmPFC_none+1;
        
    end
    
end

% ACCg

ACCg_x1=[];
ACCg_x2=[];
ACCg_none=0;
ACCg_all=length(ACCg_index);

for i=1:length(ACCg_index)
    
    if ~isempty(BigTable_Stepwise_term{ACCg_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x1') 
           ACCg_x1=[ACCg_x1 BigTable_Stepwise_coef{ACCg_index(i),5}];
       elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x2')
           ACCg_x2=[ACCg_x2 BigTable_Stepwise_coef{ACCg_index(i),5}];
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{ACCg_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),6}),'x1') 
           ACCg_x1=[ACCg_x1 BigTable_Stepwise_coef{ACCg_index(i),6}];
       elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),6}),'x2')
           ACCg_x2=[ACCg_x2 BigTable_Stepwise_coef{ACCg_index(i),6}];
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{ACCg_index(i),5}) && isempty(BigTable_Stepwise_term{ACCg_index(i),6}) 
        
        ACCg_none=ACCg_none+1;
        
    end
    
end

% BLA

BLA_x1=[];
BLA_x2=[];
BLA_none=0;
BLA_all=length(BLA_index);

for i=1:length(BLA_index)
    
    if ~isempty(BigTable_Stepwise_term{BLA_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x1') 
           BLA_x1=[BLA_x1 BigTable_Stepwise_coef{BLA_index(i),5}];
       elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x2')
           BLA_x2=[BLA_x2 BigTable_Stepwise_coef{BLA_index(i),5}];
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{BLA_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),6}),'x1') 
           BLA_x1=[BLA_x1 BigTable_Stepwise_coef{BLA_index(i),6}];
       elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),6}),'x2')
           BLA_x2=[BLA_x2 BigTable_Stepwise_coef{BLA_index(i),6}];
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{BLA_index(i),5}) && isempty(BigTable_Stepwise_term{BLA_index(i),6}) 
        
        BLA_none=BLA_none+1;
        
    end
    
end

%% Plotting distribution of coefficients

% OFC

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,1)
histogram(OFC_x1,x_m1dis);hold on
plot([median(OFC_x1) median(OFC_x1)], [0 length(OFC_x1)*0.3],'r'); hold on
title('OFC M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(OFC_x1)*0.3]);
yticks([0 length(OFC_x1)*0.1 length(OFC_x1)*0.2 length(OFC_x1)*0.3]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,5)
histogram(OFC_x2,x_m2dis); hold on
plot([median(OFC_x2) median(OFC_x2)], [0 length(OFC_x2)*0.3],'r'); hold on
title('OFC M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(OFC_x2)*0.3]);
yticks([0 length(OFC_x2)*0.1 length(OFC_x2)*0.2 length(OFC_x2)*0.3]);
axis square;

% dmPFC

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,2)
histogram(dmPFC_x1,x_m1dis);hold on
plot([median(dmPFC_x1) median(dmPFC_x1)], [0 length(dmPFC_x1)*0.3],'r'); hold on
title('dmPFC M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(dmPFC_x1)*0.3]);
yticks([0 length(dmPFC_x1)*0.1 length(dmPFC_x1)*0.2 length(dmPFC_x1)*0.3]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,6)
histogram(dmPFC_x2,x_m2dis); hold on
plot([median(dmPFC_x2) median(dmPFC_x2)], [0 length(dmPFC_x2)*0.3],'r'); hold on
title('dmPFC M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(dmPFC_x2)*0.3]);
yticks([0 length(dmPFC_x2)*0.1 length(dmPFC_x2)*0.2 length(dmPFC_x2)*0.3]);
axis square;

% ACCg

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,3)
histogram(ACCg_x1,x_m1dis);hold on
plot([median(ACCg_x1) median(ACCg_x1)], [0 length(ACCg_x1)*0.3],'r'); hold on
title('ACCg M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(ACCg_x1)*0.3]);
yticks([0 length(ACCg_x1)*0.1 length(ACCg_x1)*0.2 length(ACCg_x1)*0.3]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,7)
histogram(ACCg_x2,x_m2dis); hold on
plot([median(ACCg_x2) median(ACCg_x2)], [0 length(ACCg_x2)*0.3],'r'); hold on
title('ACCg M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(ACCg_x2)*0.3]);
yticks([0 length(ACCg_x2)*0.1 length(ACCg_x2)*0.2 length(ACCg_x2)*0.3]);
axis square;

% BLA

x_m1dis=-0.2:0.01:0.2;
subplot(2,4,4)
histogram(BLA_x1,x_m1dis);hold on
plot([median(BLA_x1) median(BLA_x1)], [0 length(BLA_x1)*0.3],'r'); hold on
title('BLA M1dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(BLA_x1)*0.3]);
yticks([0 length(BLA_x1)*0.1 length(BLA_x1)*0.2 length(BLA_x1)*0.3]);
axis square;

x_m2dis=-0.2:0.01:0.2;
subplot(2,4,8)
histogram(BLA_x2,x_m2dis); hold on
plot([median(BLA_x2) median(BLA_x2)], [0 length(BLA_x2)*0.3],'r'); hold on
title('BLA M2dis');
xlim([-0.2 0.2]);
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
ylim([0 length(BLA_x2)*0.3]);
yticks([0 length(BLA_x2)*0.1 length(BLA_x2)*0.2 length(BLA_x2)*0.3]);
axis square;

sgtitle('Distribution of coefficients of significant term')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('Distribution_sig_term'));
saveas(gcf,sprintf('Distribution_sig_term.png'));
saveas(gcf,sprintf('Distribution_sig_term.epsc'));
