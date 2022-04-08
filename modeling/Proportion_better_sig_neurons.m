%% Proportion of best (better) term (m1dis or m2dis or none)

% OFC

OFC_x1_best=0;
OFC_x2_best=0;
OFC_none_best=0;
OFC_all=length(OFC_index);

for i=1:length(OFC_index)
    
    if isempty(BigTable_Stepwise_term{OFC_index(i),5})  
        OFC_none_best=OFC_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x1')        
        OFC_x1_best=OFC_x1_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x2')
        OFC_x2_best=OFC_x2_best+1;
    end
    
end

% dmPFC

dmPFC_x1_best=0;
dmPFC_x2_best=0;
dmPFC_none_best=0;
dmPFC_all=length(dmPFC_index);

for i=1:length(dmPFC_index)
    
    if isempty(BigTable_Stepwise_term{dmPFC_index(i),5})  
        dmPFC_none_best=dmPFC_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x1')        
        dmPFC_x1_best=dmPFC_x1_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x2')
        dmPFC_x2_best=dmPFC_x2_best+1;
    end
    
end

% ACCg

ACCg_x1_best=0;
ACCg_x2_best=0;
ACCg_none_best=0;
ACCg_all=length(ACCg_index);

for i=1:length(ACCg_index)
    
    if isempty(BigTable_Stepwise_term{ACCg_index(i),5})  
        ACCg_none_best=ACCg_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x1')        
        ACCg_x1_best=ACCg_x1_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x2')
        ACCg_x2_best=ACCg_x2_best+1;
    end
    
end

% BLA

BLA_x1_best=0;
BLA_x2_best=0;
BLA_none_best=0;
BLA_all=length(BLA_index);

for i=1:length(BLA_index)
    
    if isempty(BigTable_Stepwise_term{BLA_index(i),5})  
        BLA_none_best=BLA_none_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x1')        
        BLA_x1_best=BLA_x1_best+1;
    elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x2')
        BLA_x2_best=BLA_x2_best+1;
    end
    
end

%% Plotting proportion of best (better) term

% OFC

subplot(1,4,1)
X=categorical({'other','self','none'});
X=reordercats(X,{'other' 'self' 'none'});
bar(X(1),OFC_x2_best/OFC_all,'g'); hold on
bar(X(2),OFC_x1_best/OFC_all,'b'); hold on
bar(X(3),OFC_none_best/OFC_all,'c'); hold on
title('OFC');
ylim([0 0.5]);

% dmPFC

subplot(1,4,2)
X=categorical({'other','self','none'});
X=reordercats(X,{'other' 'self' 'none'});
bar(X(1),dmPFC_x2_best/dmPFC_all,'g'); hold on
bar(X(2),dmPFC_x1_best/dmPFC_all,'b'); hold on
bar(X(3),dmPFC_none_best/dmPFC_all,'c'); hold on
title('dmPFC');
ylim([0 0.5]);

% ACCg

subplot(1,4,3)
X=categorical({'other','self','none'});
X=reordercats(X,{'other' 'self' 'none'});
bar(X(1),ACCg_x2_best/ACCg_all,'g'); hold on
bar(X(2),ACCg_x1_best/ACCg_all,'b'); hold on
bar(X(3),ACCg_none_best/ACCg_all,'c'); hold on
title('ACCg');
ylim([0 0.5]);

% BLA

subplot(1,4,4)
X=categorical({'other','self','none'});
X=reordercats(X,{'other' 'self' 'none'});
bar(X(1),BLA_x2_best/BLA_all,'g'); hold on
bar(X(2),BLA_x1_best/BLA_all,'b'); hold on
bar(X(3),BLA_none_best/BLA_all,'c'); hold on
title('BLA');
ylim([0 0.5]);

sgtitle('Proportion of significant best terms')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('Best_term'));
saveas(gcf,sprintf('Best_term.png'));
saveas(gcf,sprintf('Best_term.epsc'));


%% Proportion of significant term

% OFC

OFC_x1=0;
OFC_x2=0;
OFC_none=0;
OFC_all=length(OFC_index);

for i=1:length(OFC_index)
    
    if ~isempty(BigTable_Stepwise_term{OFC_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x1') 
           OFC_x1=OFC_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),5}),'x2')
           OFC_x2=OFC_x2+1;
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{OFC_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),6}),'x1') 
           OFC_x1=OFC_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{OFC_index(i),6}),'x2')
           OFC_x2=OFC_x2+1;
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{OFC_index(i),5}) && isempty(BigTable_Stepwise_term{OFC_index(i),6}) 
        
        OFC_none=OFC_none+1;
        
    end
    
end

% dmPFC

dmPFC_x1=0;
dmPFC_x2=0;
dmPFC_none=0;
dmPFC_all=length(dmPFC_index);

for i=1:length(dmPFC_index)
    
    if ~isempty(BigTable_Stepwise_term{dmPFC_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x1') 
           dmPFC_x1=dmPFC_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),5}),'x2')
           dmPFC_x2=dmPFC_x2+1;
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{dmPFC_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),6}),'x1') 
           dmPFC_x1=dmPFC_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{dmPFC_index(i),6}),'x2')
           dmPFC_x2=dmPFC_x2+1;
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{dmPFC_index(i),5}) && isempty(BigTable_Stepwise_term{dmPFC_index(i),6}) 
        
        dmPFC_none=dmPFC_none+1;
        
    end
    
end

% ACCg

ACCg_x1=0;
ACCg_x2=0;
ACCg_none=0;
ACCg_all=length(ACCg_index);

for i=1:length(ACCg_index)
    
    if ~isempty(BigTable_Stepwise_term{ACCg_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x1') 
           ACCg_x1=ACCg_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),5}),'x2')
           ACCg_x2=ACCg_x2+1;
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{ACCg_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),6}),'x1') 
           ACCg_x1=ACCg_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{ACCg_index(i),6}),'x2')
           ACCg_x2=ACCg_x2+1;
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{ACCg_index(i),5}) && isempty(BigTable_Stepwise_term{ACCg_index(i),6}) 
        
        ACCg_none=ACCg_none+1;
        
    end
    
end

% BLA

BLA_x1=0;
BLA_x2=0;
BLA_none=0;
BLA_all=length(BLA_index);

for i=1:length(BLA_index)
    
    if ~isempty(BigTable_Stepwise_term{BLA_index(i),5})
        
       if contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x1') 
           BLA_x1=BLA_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),5}),'x2')
           BLA_x2=BLA_x2+1;
       end
       
    end
    
    if ~isempty(BigTable_Stepwise_term{BLA_index(i),6}) 
        
       if contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),6}),'x1') 
           BLA_x1=BLA_x1+1;
       elseif contains(cell2mat(BigTable_Stepwise_term{BLA_index(i),6}),'x2')
           BLA_x2=BLA_x2+1;
       end
       
    end
    
    if isempty(BigTable_Stepwise_term{BLA_index(i),5}) && isempty(BigTable_Stepwise_term{BLA_index(i),6}) 
        
        BLA_none=BLA_none+1;
        
    end
    
end

%% Plotting proportion of significant term

% OFC

subplot(1,4,1)
X=categorical({'other','self','none'});
X=reordercats(X,{'other','self' 'none'});
bar(X(1),OFC_x2/OFC_all,'g'); hold on
bar(X(2),OFC_x1/OFC_all,'b'); hold on
bar(X(3),OFC_none/OFC_all,'c'); hold on
title('OFC');
ylim([0 0.5]);
yticks([0 0.1 0.2 0.3 0.4 0.5]);

% dmPFC

subplot(1,4,2)
X=categorical({'other','self','none'});
X=reordercats(X,{'other','self' 'none'});
bar(X(1),dmPFC_x2/dmPFC_all,'g'); hold on
bar(X(2),dmPFC_x1/dmPFC_all,'b'); hold on
bar(X(3),dmPFC_none/dmPFC_all,'c'); hold on
title('dmPFC');
ylim([0 0.5]);
yticks([0 0.1 0.2 0.3 0.4 0.5]);

% ACCg

subplot(1,4,3)
X=categorical({'other','self','none'});
X=reordercats(X,{'other','self' 'none'});
bar(X(1),ACCg_x2/ACCg_all,'g'); hold on
bar(X(2),ACCg_x1/ACCg_all,'b'); hold on
bar(X(3),ACCg_none/ACCg_all,'c'); hold on
title('ACCg');
ylim([0 0.5]);
yticks([0 0.1 0.2 0.3 0.4 0.5]);

% BLA

subplot(1,4,4)
X=categorical({'other','self','none'});
X=reordercats(X,{'other','self' 'none'});
bar(X(1),BLA_x2/BLA_all,'g'); hold on
bar(X(2),BLA_x1/BLA_all,'b'); hold on
bar(X(3),BLA_none/BLA_all,'c'); hold on
title('BLA');
ylim([0 0.5]);
yticks([0 0.1 0.2 0.3 0.4 0.5]);

sgtitle('Proportion of significant terms')
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf('Sig_term'));
saveas(gcf,sprintf('Sig_term.png'));
saveas(gcf,sprintf('Sig_term.epsc'));

%% Proportion test for bar plots (best/better term)

% Comparing m1dis and m2dis within region (two-percentage comparison using prop_test)

% OFC
[h_OFC, p_OFC, chi2stat_OFC ,df_OFC] = prop_test( [OFC_x1_best OFC_x2_best] , [OFC_all OFC_all], true);

% dmPFC
[h_dmPFC, p_dmPFC, chi2stat_dmPFC ,df_dmPFC] = prop_test( [dmPFC_x1_best dmPFC_x2_best] , [dmPFC_all dmPFC_all], true);

% ACCg
[h_ACCg, p_ACCg, chi2stat_ACCg ,df_ACCg] = prop_test( [ACCg_x1_best ACCg_x2_best] , [ACCg_all ACCg_all], true);

% BLA
[h_BLA, p_BLA, chi2stat_BLA ,df_BLA] = prop_test( [BLA_x1_best BLA_x2_best] , [BLA_all BLA_all], true);


% Comparing m1dis across regions (multiple-percentage comparison using chi2_tabular_frequencies)

% OFC dmPFC ACCg BLA

is_sig_one=[OFC_x1_best dmPFC_x1_best ACCg_x1_best BLA_x1_best];
total=[OFC_all dmPFC_all ACCg_all BLA_all];
non_sig_one=total-is_sig_one;
counts_one = [ is_sig_one non_sig_one ]';

labels = fcat.create( ...
    'region', {'OFC', 'dmPFC', 'ACCg', 'BLA', 'OFC', 'dmPFC', 'ACCg', 'BLA'} ...
  , 'is_significant', {'true', 'true', 'true', 'true', 'false', 'false', 'false', 'false'});
each = {};
rows = 'region';
cols = 'is_significant';

[chi2_info, chi2_labels] = dsp3.chi2_tabular_frequencies( counts_one, labels, each, rows, cols );
p_m1dis_across=chi2_info.p;
chi_m1dis_across=chi2_info.chi2;

clear each rows cols chi2_info chi2_labels 

% Comparing m2dis across regions (multiple-percentage comparison using chi2_tabular_frequencies)

% OFC dmPFC ACCg BLA

is_sig_one=[OFC_x2_best dmPFC_x2_best ACCg_x2_best BLA_x2_best];
total=[OFC_all dmPFC_all ACCg_all BLA_all];
non_sig_one=total-is_sig_one;
counts_one = [ is_sig_one non_sig_one ]';

labels = fcat.create( ...
    'region', {'OFC', 'dmPFC', 'ACCg', 'BLA', 'OFC', 'dmPFC', 'ACCg', 'BLA'} ...
  , 'is_significant', {'true', 'true', 'true', 'true', 'false', 'false', 'false', 'false'});
each = {};
rows = 'region';
cols = 'is_significant';

[chi2_info, chi2_labels] = dsp3.chi2_tabular_frequencies( counts_one, labels, each, rows, cols );
p_m2dis_across=chi2_info.p;
chi_m2dis_across=chi2_info.chi2;

clear each rows cols chi2_info chi2_labels 

all_together_corr=dsp3.fdr([p_OFC p_dmPFC p_ACCg p_BLA p_m1dis_across p_m2dis_across] );

%% Proportion test for bar plots (significant term)

% Comparing m1dis and m2dis within region (two-percentage comparison using prop_test)

% OFC
[h_OFC, p_OFC, chi2stat_OFC ,df_OFC] = prop_test( [OFC_x1 OFC_x2] , [OFC_all OFC_all], true);

% dmPFC
[h_dmPFC, p_dmPFC, chi2stat_dmPFC ,df_dmPFC] = prop_test( [dmPFC_x1 dmPFC_x2] , [dmPFC_all dmPFC_all], true);

% ACCg
[h_ACCg, p_ACCg, chi2stat_ACCg ,df_ACCg] = prop_test( [ACCg_x1 ACCg_x2] , [ACCg_all ACCg_all], true);

% BLA
[h_BLA, p_BLA, chi2stat_BLA ,df_BLA] = prop_test( [BLA_x1 BLA_x2] , [BLA_all BLA_all], true);

% Comparing m1dis across regions (multiple-percentage comparison using chi2_tabular_frequencies)

% OFC dmPFC ACCg BLA

is_sig_one=[OFC_x1 dmPFC_x1 ACCg_x1 BLA_x1];
total=[OFC_all dmPFC_all ACCg_all BLA_all];
non_sig_one=total-is_sig_one;
counts_one = [ is_sig_one non_sig_one ]';

labels = fcat.create( ...
    'region', {'OFC', 'dmPFC', 'ACCg', 'BLA', 'OFC', 'dmPFC', 'ACCg', 'BLA'} ...
  , 'is_significant', {'true', 'true', 'true', 'true', 'false', 'false', 'false', 'false'});
each = {};
rows = 'region';
cols = 'is_significant';

[chi2_info, chi2_labels] = dsp3.chi2_tabular_frequencies( counts_one, labels, each, rows, cols );
p_m1dis_across=chi2_info.p;
chi_m1dis_across=chi2_info.chi2;

clear each rows cols chi2_info chi2_labels 

% Comparing m2dis across regions (multiple-percentage comparison using chi2_tabular_frequencies)

% OFC dmPFC ACCg BLA

is_sig_one=[OFC_x2 dmPFC_x2 ACCg_x2 BLA_x2];
total=[OFC_all dmPFC_all ACCg_all BLA_all];
non_sig_one=total-is_sig_one;
counts_one = [ is_sig_one non_sig_one ]';

labels = fcat.create( ...
    'region', {'OFC', 'dmPFC', 'ACCg', 'BLA', 'OFC', 'dmPFC', 'ACCg', 'BLA'} ...
  , 'is_significant', {'true', 'true', 'true', 'true', 'false', 'false', 'false', 'false'});
each = {};
rows = 'region';
cols = 'is_significant';

[chi2_info, chi2_labels] = dsp3.chi2_tabular_frequencies( counts_one, labels, each, rows, cols );
p_m2dis_across=chi2_info.p;
chi_m2dis_across=chi2_info.chi2;

clear each rows cols chi2_info chi2_labels 

all_together_corr=dsp3.fdr([p_OFC p_dmPFC p_ACCg p_BLA p_m1dis_across p_m2dis_across] );
