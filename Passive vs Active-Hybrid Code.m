%% Comparison Script: Base IRS vs Active/Hybrid IRS
% This script compares the performance of passive IRS with active/hybrid IRS

clear all; close all; clc;

%% Load both results
load('IRS_NOMA_Base_Results.mat');
base_results = results;
base_SNR = SNR_dB;

load('IRS_NOMA_Active_Results.mat');
active_results = results;
active_SNR = SNR_dB;

%% Setup plot parameters
linewidth = 2.5;
markersize = 8;
fontsize = 13;
colors = lines(7);

%% Comparison Graph 1: Downlink NOMA - User F (Most significant improvement)
figure('Position', [100, 100, 1000, 700]);

% K=8
subplot(2,2,1);
semilogy(base_SNR, base_results.DL_NOMA.K8.OP_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(1,:), 'DisplayName', 'Passive IRS');
hold on;
semilogy(active_SNR, active_results.DL_NOMA.K8.OP_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(2,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Outage Probability', 'FontSize', fontsize);
title('DL NOMA - User F (K=8)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'southwest', 'FontSize', fontsize-1);
ylim([1e-5 1]);

% K=10
subplot(2,2,2);
semilogy(base_SNR, base_results.DL_NOMA.K10.OP_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(1,:), 'DisplayName', 'Passive IRS');
hold on;
semilogy(active_SNR, active_results.DL_NOMA.K10.OP_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(2,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Outage Probability', 'FontSize', fontsize);
title('DL NOMA - User F (K=10)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'southwest', 'FontSize', fontsize-1);
ylim([1e-5 1]);

% Ergodic Rate K=8
subplot(2,2,3);
plot(base_SNR, base_results.DL_NOMA.K8.ER_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(1,:), 'DisplayName', 'Passive IRS');
hold on;
plot(active_SNR, active_results.DL_NOMA.K8.ER_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(2,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Ergodic Rate (bps/Hz)', 'FontSize', fontsize);
title('DL NOMA - User F ER (K=8)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', fontsize-1);

% Ergodic Rate K=10
subplot(2,2,4);
plot(base_SNR, base_results.DL_NOMA.K10.ER_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(1,:), 'DisplayName', 'Passive IRS');
hold on;
plot(active_SNR, active_results.DL_NOMA.K10.ER_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(2,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Ergodic Rate (bps/Hz)', 'FontSize', fontsize);
title('DL NOMA - User F ER (K=10)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', fontsize-1);

sgtitle('Comparison: Passive vs Active/Hybrid IRS (Downlink NOMA - User F)', ...
    'FontSize', fontsize+3, 'FontWeight', 'bold');

saveas(gcf, 'Comparison_DL_NOMA_UserF.fig');
saveas(gcf, 'Comparison_DL_NOMA_UserF.png');

%% Comparison Graph 2: Downlink OMA - User F
figure('Position', [100, 100, 1000, 700]);

% K=8
subplot(2,2,1);
semilogy(base_SNR, base_results.DL_OMA.K8.OP_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(3,:), 'DisplayName', 'Passive IRS');
hold on;
semilogy(active_SNR, active_results.DL_OMA.K8.OP_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(4,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Outage Probability', 'FontSize', fontsize);
title('DL OMA - User F (K=8)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'southwest', 'FontSize', fontsize-1);
ylim([1e-5 1]);

% K=10
subplot(2,2,2);
semilogy(base_SNR, base_results.DL_OMA.K10.OP_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(3,:), 'DisplayName', 'Passive IRS');
hold on;
semilogy(active_SNR, active_results.DL_OMA.K10.OP_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(4,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Outage Probability', 'FontSize', fontsize);
title('DL OMA - User F (K=10)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'southwest', 'FontSize', fontsize-1);
ylim([1e-5 1]);

% Ergodic Rate K=8
subplot(2,2,3);
plot(base_SNR, base_results.DL_OMA.K8.ER_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(3,:), 'DisplayName', 'Passive IRS');
hold on;
plot(active_SNR, active_results.DL_OMA.K8.ER_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(4,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Ergodic Rate (bps/Hz)', 'FontSize', fontsize);
title('DL OMA - User F ER (K=8)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', fontsize-1);

% Ergodic Rate K=10
subplot(2,2,4);
plot(base_SNR, base_results.DL_OMA.K10.ER_F, '-s', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(3,:), 'DisplayName', 'Passive IRS');
hold on;
plot(active_SNR, active_results.DL_OMA.K10.ER_F, '-o', 'LineWidth', linewidth, ...
    'MarkerSize', markersize, 'Color', colors(4,:), 'DisplayName', 'Active/Hybrid IRS');
grid on;
xlabel('Transmit SNR (dB)', 'FontSize', fontsize);
ylabel('Ergodic Rate (bps/Hz)', 'FontSize', fontsize);
title('DL OMA - User F ER (K=10)', 'FontSize', fontsize+1, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', fontsize-1);

sgtitle('Comparison: Passive vs Active/Hybrid IRS (Downlink OMA - User F)', ...
    'FontSize', fontsize+3, 'FontWeight', 'bold');

saveas(gcf, 'Comparison_DL_OMA_UserF.fig');
saveas(gcf, 'Comparison_DL_OMA_UserF.png');

%% Performance Gain Analysis
fprintf('\n=== Performance Gain Analysis ===\n\n');

% Calculate improvement at specific SNR points
SNR_points = [20, 30, 40]; % dB

for i = 1:length(SNR_points)
    snr_val = SNR_points(i);
    idx = find(base_SNR == snr_val);
    
    if ~isempty(idx)
        fprintf('At SNR = %d dB:\n', snr_val);
        
        % Downlink NOMA User F - K=10
        base_op = base_results.DL_NOMA.K10.OP_F(idx);
        active_op = active_results.DL_NOMA.K10.OP_F(idx);
        improvement = (base_op - active_op) / base_op * 100;
        fprintf('  DL NOMA User F (K=10) OP: %.2f%% improvement\n', improvement);
        
        base_er = base_results.DL_NOMA.K10.ER_F(idx);
        active_er = active_results.DL_NOMA.K10.ER_F(idx);
        improvement = (active_er - base_er) / base_er * 100;
        fprintf('  DL NOMA User F (K=10) ER: %.2f%% improvement\n', improvement);
        
        % Downlink OMA User F - K=10
        base_op = base_results.DL_OMA.K10.OP_F(idx);
        active_op = active_results.DL_OMA.K10.OP_F(idx);
        improvement = (base_op - active_op) / base_op * 100;
        fprintf('  DL OMA User F (K=10) OP: %.2f%% improvement\n', improvement);
        
        base_er = base_results.DL_OMA.K10.ER_F(idx);
        active_er = active_results.DL_OMA.K10.ER_F(idx);
        improvement = (active_er - base_er) / base_er * 100;
        fprintf('  DL OMA User F (K=10) ER: %.2f%% improvement\n\n', improvement);
    end
end

fprintf('All comparison plots generated successfully.\n');
