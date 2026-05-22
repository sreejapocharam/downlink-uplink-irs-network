clc; 
clear; 
close all;

% Simulation Parameters (from base paper)
SNR_dB = 0:5:50;  % SNR range (dB)
SNR = 10.^(SNR_dB/10);  % Convert dB to linear scale
K = 10;  % Number of IRS reflecting elements
mG = 3;  % Nakagami fading parameter for BS-IRS
mg = 2;  % Nakagami fading parameter for IRS-User
a1 = 0.1; a2 = 0.9;  % Power allocation coefficients for NOMA
b = K * (1 - (1 / (mG * mg)));  % IRS path gain factor

% OP Initialization
OP_IRS_N = zeros(size(SNR));
OP_IRS_F = zeros(size(SNR));
OP_FDR_N = zeros(size(SNR));
OP_FDR_F = zeros(size(SNR));
OP_IRS_OMA_N = zeros(size(SNR));
OP_IRS_OMA_F = zeros(size(SNR));

% ER Initialization
ER_IRS_N = zeros(size(SNR));
ER_IRS_F = zeros(size(SNR));
ER_FDR_N = zeros(size(SNR));
ER_FDR_F = zeros(size(SNR));
ER_IRS_OMA_N = zeros(size(SNR));
ER_IRS_OMA_F = zeros(size(SNR));

% Loop over SNR values
for i = 1:length(SNR)
    rho = SNR(i);
    
    % Outage Probability (IRS)
    OP_IRS_N(i) = 1 - exp(- (2^(2*a1) - 1) / rho);
    OP_IRS_F(i) = exp(-b * (2^(2*a2) - 1) / rho);
    OP_IRS_OMA_N(i) = 1 - exp(- (2^(2*a1) - 1) / (2*rho));
    OP_IRS_OMA_F(i) = exp(-b * (2^(2*a2) - 1) / (2*rho));
    
    % Outage Probability (FDR)
    OP_FDR_N(i) = 1 - exp(- (2^(2*a1) - 1) / (rho / 2));
    OP_FDR_F(i) = 1 - exp(- (2^(2*a2) - 1) / (rho / 2));
    
    % Ergodic Rate (IRS)
    ER_IRS_N(i) = log2(1 + rho * a1);
    ER_IRS_F(i) = log2(1 + b * rho * a2);
    ER_IRS_OMA_N(i) = 0.5 * log2(1 + 2 * rho * a1);
    ER_IRS_OMA_F(i) = 0.5 * log2(1 + 2 * b * rho * a2);
    
    % Ergodic Rate (FDR)
    ER_FDR_N(i) = log2(1 + (rho / 2) * a1);
    ER_FDR_F(i) = log2(1 + (rho / 2) * a2);
end
%% **Figure 1: System Model**
figure;
hold on;
rectangle('Position', [0 2 1 1], 'FaceColor', 'b'); % Base Station (BS)
rectangle('Position', [3 2 1 1], 'FaceColor', 'g'); % IRS
rectangle('Position', [6 2 1 1], 'FaceColor', 'r'); % User Device (F)
rectangle('Position', [6 0 1 1], 'FaceColor', 'none'); % User Device (N)
plot([1, 3], [2.5, 2.5], 'k--', 'LineWidth', 2); % BS to IRS
plot([3, 6], [2.5, 2.5], 'k-', 'LineWidth', 2); % IRS to F
plot([1, 6], [2.5, 0.5], 'k-', 'LineWidth', 2); % BS to N
text(0.2, 2.8, 'BS', 'FontSize', 12, 'Color', 'w');
text(3.2, 2.8, 'IRS', 'FontSize', 12, 'Color', 'w');
text(6.2, 2.8, 'User F', 'FontSize', 12, 'Color', 'w');
text(6.2, 0.8, 'User N', 'FontSize', 12, 'Color', 'w');
title('IRS-Aided NOMA System Model');
hold off;
%% **Figure 2: PDF and CDF Verification**
num_samples = 10^6;
K = 30; mG = 3; mg = 1.5;
X = sum(sqrt(random('Nakagami', mG, 1, num_samples, K)) .* ...
         sqrt(random('Nakagami', mg, 1, num_samples, K)), 2).^2;
[f, x] = ksdensity(X);
figure;
subplot(1,2,1);
plot(x, f, 'b', 'LineWidth', 2); hold on;
xlabel('X'); ylabel('PDF'); title('PDF Verification');
grid on;
subplot(1,2,2);
plot(x, cumsum(f)/sum(f), 'r', 'LineWidth', 2);
xlabel('X'); ylabel('CDF'); title('CDF Verification');
grid on;

% Figure 1: Downlink Outage Probability
figure;
semilogy(SNR_dB, OP_IRS_N, 'b-o', 'LineWidth', 1.5); hold on;
semilogy(SNR_dB, OP_IRS_F, 'b--o', 'LineWidth', 1.5);
semilogy(SNR_dB, OP_FDR_N, 'r-s', 'LineWidth', 1.5);
semilogy(SNR_dB, OP_FDR_F, 'r--s', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)'); ylabel('Outage Probability');
legend('IRS NOMA (N)', 'IRS NOMA (F)', 'FDR NOMA (N)', 'FDR NOMA (F)');
title('Figure 1: Downlink Outage Probability');

% Figure 2: Uplink Outage Probability
figure;
semilogy(SNR_dB, OP_IRS_OMA_N, 'g-o', 'LineWidth', 1.5); hold on;
semilogy(SNR_dB, OP_IRS_OMA_F, 'g--o', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)'); ylabel('Outage Probability');
legend('IRS OMA (N)', 'IRS OMA (F)');
title('Figure 2: Uplink Outage Probability');

% Figure 3: Downlink Ergodic Rate
figure;
plot(SNR_dB, ER_IRS_N, 'b-o', 'LineWidth', 1.5); hold on;
plot(SNR_dB, ER_IRS_F, 'b--o', 'LineWidth', 1.5);
plot(SNR_dB, ER_FDR_N, 'r-s', 'LineWidth', 1.5);
plot(SNR_dB, ER_FDR_F, 'r--s', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)'); ylabel('Ergodic Rate (bps/Hz)');
legend('IRS NOMA (N)', 'IRS NOMA (F)', 'FDR NOMA (N)', 'FDR NOMA (F)');
title('Figure 3: Downlink Ergodic Rate');

% Figure 4: Uplink Ergodic Rate                     
figure;
plot(SNR_dB, ER_IRS_OMA_N, 'g-o', 'LineWidth', 1.5); hold on;
plot(SNR_dB, ER_IRS_OMA_F, 'g--o', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)'); ylabel('Ergodic Rate (bps/Hz)');
legend('IRS OMA (N)', 'IRS OMA (F)');
title('Figure 4: Uplink Ergodic Rate');

% Figure 5: OP Comparison (NOMA vs. OMA)
figure;
semilogy(SNR_dB, OP_IRS_N, 'b-o', 'LineWidth', 1.5); hold on;
semilogy(SNR_dB, OP_IRS_OMA_N, 'g--o', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)'); ylabel('Outage Probability');
legend('IRS NOMA (N)', 'IRS OMA (N)');
title('Figure 5: OP Comparison (NOMA vs. OMA)');

% Figure 6: ER Comparison (NOMA vs. OMA)
figure;
plot(SNR_dB, ER_IRS_N, 'b-o', 'LineWidth', 1.5); hold on;
plot(SNR_dB, ER_IRS_OMA_N, 'g--o', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)'); ylabel('Ergodic Rate (bps/Hz)');
legend('IRS NOMA (N)', 'IRS OMA (N)');
title('Figure 6: ER Comparison (NOMA vs. OMA)');