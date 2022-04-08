% Compare pre (10:19) vs. post (20:29) and compare across regions for each condition

Condition=Eyes_Object_matched;
FileName='Eyes_Object_matched';

OFC_pre=Condition.OFC.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,10:19);
OFC_post=Condition.OFC.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,20:29);

OFC_pre_mean=mean(OFC_pre, [2 3]);
OFC_post_mean=mean(OFC_post, [2 3]);

dmPFC_pre=Condition.dmPFC.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,10:19);
dmPFC_post=Condition.dmPFC.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,20:29);

dmPFC_pre_mean=mean(dmPFC_pre, [2 3]);
dmPFC_post_mean=mean(dmPFC_post, [2 3]);

ACCg_pre=Condition.ACCg.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,10:19);
ACCg_post=Condition.ACCg.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,20:29);

ACCg_pre_mean=mean(ACCg_pre, [2 3]);
ACCg_post_mean=mean(ACCg_post, [2 3]);

BLA_pre=Condition.BLA.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,10:19);
BLA_post=Condition.BLA.ZERO_ONE_LOSS_RESULTS.decoding_results(:,:,20:29);

BLA_pre_mean=mean(BLA_pre, [2 3]);
BLA_post_mean=mean(BLA_post, [2 3]);

%% Compare pre to post for each region separately (signrank is paired because pre and post are from the same iteration)

[OFC_pre_post_p,OFC_pre_post_h]=signrank(OFC_pre_mean,OFC_post_mean);
[dmPFC_pre_post_p,dmPFC_pre_post_h]=signrank(dmPFC_pre_mean,dmPFC_post_mean);
[ACCg_pre_post_p,ACCg_pre_post_h]=signrank(ACCg_pre_mean,ACCg_post_mean);
[BLA_pre_post_p,BLA_pre_post_h]=signrank(BLA_pre_mean,BLA_post_mean);

%% compare regions for each time epoch separately (ranksum is unpaired)

[OFC_dmPFC_pre_p,OFC_dmPFC_pre_h]=ranksum(OFC_pre_mean,dmPFC_pre_mean);
[OFC_dmPFC_post_p,OFC_dmPFC_post_h]=ranksum(OFC_post_mean,dmPFC_post_mean);

[OFC_ACCg_pre_p,OFC_ACCg_pre_h]=ranksum(OFC_pre_mean,ACCg_pre_mean);
[OFC_ACCg_post_p,OFC_ACCg_post_h]=ranksum(OFC_post_mean,ACCg_post_mean);

[OFC_BLA_pre_p,OFC_BLA_pre_h]=ranksum(OFC_pre_mean,BLA_pre_mean);
[OFC_BLA_post_p,OFC_BLA_post_h]=ranksum(OFC_post_mean,BLA_post_mean);

[dmPFC_ACCg_pre_p,dmPFC_ACCg_pre_h]=ranksum(dmPFC_pre_mean,ACCg_pre_mean);
[dmPFC_ACCg_post_p,dmPFC_ACCg_post_h]=ranksum(dmPFC_post_mean,ACCg_post_mean);

[dmPFC_BLA_pre_p,dmPFC_BLA_pre_h]=ranksum(dmPFC_pre_mean,BLA_pre_mean);
[dmPFC_BLA_post_p,dmPFC_BLA_post_h]=ranksum(dmPFC_post_mean,BLA_post_mean);

[ACCg_BLA_pre_p,ACCg_BLA_pre_h]=ranksum(ACCg_pre_mean,BLA_pre_mean);
[ACCg_BLA_post_p,ACCg_BLA_post_h]=ranksum(ACCg_post_mean,BLA_post_mean);

corrected_p=dsp3.fdr([OFC_pre_post_p dmPFC_pre_post_p ACCg_pre_post_p BLA_pre_post_p...
    OFC_dmPFC_pre_p OFC_dmPFC_post_p OFC_ACCg_pre_p OFC_ACCg_post_p OFC_BLA_pre_p OFC_BLA_post_p...
    dmPFC_ACCg_pre_p dmPFC_ACCg_post_p dmPFC_BLA_pre_p dmPFC_BLA_post_p ACCg_BLA_pre_p ACCg_BLA_post_p] );


%% save fdr corrected p values

save([FileName '_stats.mat'],'corrected_p');

%% Plotting median

subplot(1,2,1)
bar([median(OFC_pre_mean),median(dmPFC_pre_mean),median(ACCg_pre_mean),median(BLA_pre_mean)]); hold on
scatter(repmat(1,[100 1]),OFC_pre_mean,20); hold on
scatter(repmat(2,[100 1]),dmPFC_pre_mean,20); hold on
scatter(repmat(3,[100 1]),ACCg_pre_mean,20); hold on
scatter(repmat(4,[100 1]),BLA_pre_mean,20); hold on
ylim([0 1]);
title('pre epoch: -500ms to 0');

subplot(1,2,2)
bar([median(OFC_post_mean),median(dmPFC_post_mean),median(ACCg_post_mean),median(BLA_post_mean)]); hold on
scatter(repmat(1,[100 1]),OFC_post_mean,20); hold on
scatter(repmat(2,[100 1]),dmPFC_post_mean,20); hold on
scatter(repmat(3,[100 1]),ACCg_post_mean,20); hold on
scatter(repmat(4,[100 1]),BLA_post_mean,20); hold on
ylim([0 1]);
title('post epoch: 0 to 500ms');

sgtitle(['Decoding pre vs. post comparison' FileName])
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf(['Decoding_' FileName]));
saveas(gcf,sprintf(['Decoding_' FileName '.epsc']));
saveas(gcf,sprintf(['Decoding_' FileName '.png']));
