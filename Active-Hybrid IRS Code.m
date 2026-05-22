%% IRS-Aided NOMA/OMA Networks - Active/Hybrid IRS Extension
% This code extends the base paper implementation with Active/Hybrid IRS
% Active IRS includes amplifying elements to overcome double-fading

clear all; close all; clc;

%% System Parameters
K_values = [8, 10];           % Number of IRS reflecting elements
mG = 3;                        % Nakagami fading parameter for BS-IRS link
mg = 2;                        % Nakagami fading parameter for IRS-F link
mh = 1;                        % Rayleigh fading for BS-N link

% Distance parameters
dN = 10;                       % Distance BS to N (meters)
dF1 = 45;                      % Distance BS to IRS (meters)
dF2 = 5;                       % Distance IRS to F (meters)

% Path loss exponents
alpha_h = 2.5;                 % Path loss exponent for BS-N
alpha_G = 2.2;                 % Path loss exponent for BS-IRS
alpha_g = 2.8;                 % Path loss exponent for IRS-F

% Power allocation coefficients for NOMA
alpha1 = 0.2;                  % Power allocation for near user N
alpha2 = 0.8;                  % Power allocation for far user F

% Active IRS parameters
beta = 1;                      % Amplitude reflection coefficient
G_amp = 3;                     % Amplification gain (linear scale)
                               % This overcomes the double fading effect
P_active = 0.1;                % Fraction of active elements (0.1 = 10%)

% SNR range
SNR_dB = 0:5:50;
SNR_linear = 10.^(SNR_dB/10);
rho = SNR_linear;

% Target rates for outage probability
R_tilde_N = 1;                % Target rate for N (bps/Hz)
R_tilde_F = 0.5;              % Target rate for F (bps/Hz)
gamma_tilde_N = 2^R_tilde_N - 1;
gamma_tilde_F = 2^R_tilde_F - 1;

% OMA target rates
R_tilde_N_OMA = 2*R_tilde_N;
R_tilde_F_OMA = 2*R_tilde_F;
gamma_tilde_N_OMA = 2^R_tilde_N_OMA - 1;
gamma_tilde_F_OMA = 2^R_tilde_F_OMA - 1;

% Monte Carlo simulation parameters
N_Monte = 1e5;

% Pre-compute path loss terms
a = dN^(-alpha_h);
path_loss_IRS = dF1^(-alpha_G) * dF2^(-alpha_g);

%% Calculate lambda parameter
xi = (1/mG/mg) * (gamma(mG+0.5)/gamma(mG))^2 * (gamma(mg+0.5)/gamma(mg))^2;

%% Main Simulation Loop for Different K values
for k_idx = 1:length(K_values)
    K = K_values(k_idx);
    
    % Number of active elements
    K_active = round(P_active * K);
    K_passive = K - K_active;
    
    % Enhanced b parameter due to active elements
    % Active elements provide amplification gain
    b_active = K * beta^2 * path_loss_IRS * (1-xi) * G_amp;
    
    lambda = K * xi / (1-xi);
    
    fprintf('Running simulations for K = %d (Active Elements: %d)\n', K, K_active);
    
    %% ============ DOWNLINK NOMA WITH ACTIVE IRS ============
    fprintf('  Downlink NOMA with Active IRS...\n');
    
    % Initialize arrays
    OP_N_NOMA_DL_active = zeros(size(SNR_dB));
    OP_F_NOMA_DL_active = zeros(size(SNR_dB));
    ER_N_NOMA_DL_active = zeros(size(SNR_dB));
    ER_F_NOMA_DL_active = zeros(size(SNR_dB));
    
    for snr_idx = 1:length(SNR_linear)
        rho_val = SNR_linear(snr_idx);
        
        % Monte Carlo simulation
        outage_N = 0;
        outage_F = 0;
        sum_rate_N = 0;
        sum_rate_F = 0;
        
        for iter = 1:N_Monte
            % Generate channel coefficients
            h = (randn + 1j*randn) / sqrt(2);
            Y = abs(h)^2;
            
            % Hybrid IRS: some elements are active, others passive
            G = zeros(1, K);
            g = zeros(K, 1);
            
            for k = 1:K
                G(k) = sqrt(gamrnd(mG, 1/mG)) * exp(1j*2*pi*rand);
                g(k) = sqrt(gamrnd(mg, 1/mg)) * exp(1j*2*pi*rand);
            end
            
            % Apply amplification to active elements
            active_indices = randperm(K, K_active);
            G_effective = G;
            g_effective = g;
            
            for idx = 1:K_active
                k = active_indices(idx);
                % Active elements amplify the signal
                g_effective(k) = g(k) * sqrt(G_amp);
            end
            
            % Optimal phase alignment with active elements
            X_sum = sum(abs(G_effective) .* abs(g_effective'));
            X_active = (X_sum)^2;
            
            % SINR and SNR calculations
            SINR_N_F = (a*alpha2*Y) / (a*alpha1*Y + 1/rho_val);
            SNR_N = a*alpha1*rho_val*Y;
            SINR_F = (b_active*alpha2*X_active) / (b_active*alpha1*X_active + 1/rho_val);
            
            % Outage events
            if (SINR_N_F < gamma_tilde_F) || (SNR_N < gamma_tilde_N)
                outage_N = outage_N + 1;
            end
            if SINR_F < gamma_tilde_F
                outage_F = outage_F + 1;
            end
            
            % Ergodic rates
            sum_rate_N = sum_rate_N + log2(1 + SNR_N);
            sum_rate_F = sum_rate_F + log2(1 + SINR_F);
        end
        
        OP_N_NOMA_DL_active(snr_idx) = outage_N / N_Monte;
        OP_F_NOMA_DL_active(snr_idx) = outage_F / N_Monte;
        ER_N_NOMA_DL_active(snr_idx) = sum_rate_N / N_Monte;
        ER_F_NOMA_DL_active(snr_idx) = sum_rate_F / N_Monte;
    end
    
    % Store results
    results.DL_NOMA.(['K' num2str(K)]).OP_N = OP_N_NOMA_DL_active;
    results.DL_NOMA.(['K' num2str(K)]).OP_F = OP_F_NOMA_DL_active;
    results.DL_NOMA.(['K' num2str(K)]).ER_N = ER_N_NOMA_DL_active;
    results.DL_NOMA.(['K' num2str(K)]).ER_F = ER_F_NOMA_DL_active;
    
    %% ============ DOWNLINK OMA WITH ACTIVE IRS ============
    fprintf('  Downlink OMA with Active IRS...\n');
    
    % Initialize arrays
    OP_N_OMA_DL_active = zeros(size(SNR_dB));
    OP_F_OMA_DL_active = zeros(size(SNR_dB));
    ER_N_OMA_DL_active = zeros(size(SNR_dB));
    ER_F_OMA_DL_active = zeros(size(SNR_dB));
    
    for snr_idx = 1:length(SNR_linear)
        rho_val = SNR_linear(snr_idx);
        
        outage_N = 0;
        outage_F = 0;
        sum_rate_N = 0;
        sum_rate_F = 0;
        
        for iter = 1:N_Monte
            h = (randn + 1j*randn) / sqrt(2);
            Y = abs(h)^2;
            
            G = zeros(1, K);
            g = zeros(K, 1);
            
            for k = 1:K
                G(k) = sqrt(gamrnd(mG, 1/mG)) * exp(1j*2*pi*rand);
                g(k) = sqrt(gamrnd(mg, 1/mg)) * exp(1j*2*pi*rand);
            end
            
            % Apply amplification to active elements
            active_indices = randperm(K, K_active);
            G_effective = G;
            g_effective = g;
            
            for idx = 1:K_active
                k = active_indices(idx);
                g_effective(k) = g(k) * sqrt(G_amp);
            end
            
            X_sum = sum(abs(G_effective) .* abs(g_effective'));
            X_active = (X_sum)^2;
            
            % SNR calculations for OMA
            SNR_N_OMA = a * rho_val * Y;
            SNR_F_OMA = b_active * rho_val * X_active;
            
            % Outage events
            if SNR_N_OMA < gamma_tilde_N_OMA
                outage_N = outage_N + 1;
            end
            if SNR_F_OMA < gamma_tilde_F_OMA
                outage_F = outage_F + 1;
            end
            
            % Ergodic rates
            sum_rate_N = sum_rate_N + 0.5*log2(1 + SNR_N_OMA);
            sum_rate_F = sum_rate_F + 0.5*log2(1 + SNR_F_OMA);
        end
        
        OP_N_OMA_DL_active(snr_idx) = outage_N / N_Monte;
        OP_F_OMA_DL_active(snr_idx) = outage_F / N_Monte;
        ER_N_OMA_DL_active(snr_idx) = sum_rate_N / N_Monte;
        ER_F_OMA_DL_active(snr_idx) = sum_rate_F / N_Monte;
    end
    
    % Store results
    results.DL_OMA.(['K' num2str(K)]).OP_N = OP_N_OMA_DL_active;
    results.DL_OMA.(['K' num2str(K)]).OP_F = OP_F_OMA_DL_active;
    results.DL_OMA.(['K' num2str(K)]).ER_N = ER_N_OMA_DL_active;
    results.DL_OMA.(['K' num2str(K)]).ER_F = ER_F_OMA_DL_active;
    
    %% ============ UPLINK NOMA WITH ACTIVE IRS ============
    fprintf('  Uplink NOMA with Active IRS...\n');
    
    % Initialize arrays
    OP_N_NOMA_UL_active = zeros(size(SNR_dB));
    OP_F_NOMA_UL_active = zeros(size(SNR_dB));
    ER_N_NOMA_UL_active = zeros(size(SNR_dB));
    ER_F_NOMA_UL_active = zeros(size(SNR_dB));
    
    for snr_idx = 1:length(SNR_linear)
        rho_val = SNR_linear(snr_idx);
        
        outage_N = 0;
        outage_F = 0;
        sum_rate_N = 0;
        sum_rate_F = 0;
        
        for iter = 1:N_Monte
            h = (randn + 1j*randn) / sqrt(2);
            Y = abs(h)^2;
            
            G = zeros(1, K);
            g = zeros(K, 1);
            
            for k = 1:K
                G(k) = sqrt(gamrnd(mG, 1/mG)) * exp(1j*2*pi*rand);
                g(k) = sqrt(gamrnd(mg, 1/mg)) * exp(1j*2*pi*rand);
            end
            
            % Apply amplification to active elements
            active_indices = randperm(K, K_active);
            G_effective = G;
            g_effective = g;
            
            for idx = 1:K_active
                k = active_indices(idx);
                g_effective(k) = g(k) * sqrt(G_amp);
            end
            
            X_sum = sum(abs(G_effective) .* abs(g_effective'));
            X_active = (X_sum)^2;
            
            % SINR and SNR for uplink
            SINR_N_UL = (a*Y) / (b_active*X_active + 1/rho_val);
            SNR_F_UL = b_active * rho_val * X_active;
            
            % Outage events
            if SINR_N_UL < gamma_tilde_N
                outage_N = outage_N + 1;
            end
            if (SINR_N_UL < gamma_tilde_N) || (SNR_F_UL < gamma_tilde_F)
                outage_F = outage_F + 1;
            end
            
            % Ergodic rates
            sum_rate_N = sum_rate_N + log2(1 + SINR_N_UL);
            sum_rate_F = sum_rate_F + log2(1 + SNR_F_UL);
        end
        
        OP_N_NOMA_UL_active(snr_idx) = outage_N / N_Monte;
        OP_F_NOMA_UL_active(snr_idx) = outage_F / N_Monte;
        ER_N_NOMA_UL_active(snr_idx) = sum_rate_N / N_Monte;
        ER_F_NOMA_UL_active(snr_idx) = sum_rate_F / N_Monte;
    end
    
    % Store results
    results.UL_NOMA.(['K' num2str(K)]).OP_N = OP_N_NOMA_UL_active;
    results.UL_NOMA.(['K' num2str(K)]).OP_F = OP_F_NOMA_UL_active;
    results.UL_NOMA.(['K' num2str(K)]).ER_N = ER_N_NOMA_UL_active;
    results.UL_NOMA.(['K' num2str(K)]).ER_F = ER_F_NOMA_UL_active;
    
    %% ============ UPLINK OMA WITH ACTIVE IRS ============
    fprintf('  Uplink OMA with Active IRS...\n');
    
    % Initialize arrays
    OP_N_OMA_UL_active = zeros(size(SNR_dB));
    OP_F_OMA_UL_active = zeros(size(SNR_dB));
    ER_N_OMA_UL_active = zeros(size(SNR_dB));
    ER_F_OMA_UL_active = zeros(size(SNR_dB));
    
    for snr_idx = 1:length(SNR_linear)
        rho_val = SNR_linear(snr_idx);
        
        outage_N = 0;
        outage_F = 0;
        sum_rate_N = 0;
        sum_rate_F = 0;
        
        for iter = 1:N_Monte
            h = (randn + 1j*randn) / sqrt(2);
            Y = abs(h)^2;
            
            G = zeros(1, K);
            g = zeros(K, 1);
            
            for k = 1:K
                G(k) = sqrt(gamrnd(mG, 1/mG)) * exp(1j*2*pi*rand);
                g(k) = sqrt(gamrnd(mg, 1/mg)) * exp(1j*2*pi*rand);
            end
            
            % Apply amplification to active elements
            active_indices = randperm(K, K_active);
            G_effective = G;
            g_effective = g;
            
            for idx = 1:K_active
                k = active_indices(idx);
                g_effective(k) = g(k) * sqrt(G_amp);
            end
            
            X_sum = sum(abs(G_effective) .* abs(g_effective'));
            X_active = (X_sum)^2;
            
            % SNR for uplink OMA
            SNR_N_UL_OMA = a * rho_val * Y;
            SNR_F_UL_OMA = b_active * rho_val * X_active;
            
            % Outage events
            if SNR_N_UL_OMA < gamma_tilde_N_OMA
                outage_N = outage_N + 1;
            end
            if SNR_F_UL_OMA < gamma_tilde_F_OMA
                outage_F = outage_F + 1;
            end
            
            % Ergodic rates
            sum_rate_N = sum_rate_N + 0.5*log2(1 + SNR_N_UL_OMA);
            sum_rate_F = sum_rate_F + 0.5*log2(1 + SNR_F_UL_OMA);
        end
        
        OP_N_OMA_UL_active(snr_idx) = outage_N / N_Monte;
        OP_F_OMA_UL_active(snr_idx) = outage_F / N_Monte;
        ER_N_OMA_UL_active(snr_idx) = sum_rate_N / N_Monte;
        ER_F_OMA_UL_active(snr_idx) = sum_rate_F / N_Monte;
    end
    
    % Store results
    results.UL_OMA.(['K' num2str(K)]).OP_N = OP_N_OMA_UL_active;
    results.UL_OMA.(['K' num2str(K)]).OP_F = OP_F_OMA_UL_active;
    results.UL_OMA.(['K' num2str(K)]).ER_N = ER_N_OMA_UL_active;
    results.UL_OMA.(['K' num2str(K)]).ER_F = ER_F_OMA_UL_active;
end

%% Save results
save('IRS_NOMA_Active_Results.mat', 'results', 'SNR_dB', 'K_values', 'G_amp', 'P_active');
fprintf('\nSimulation completed. Results saved to IRS_NOMA_Active_Results.mat\n');

%% Generate Plots
plot_IRS_NOMA_results('IRS_NOMA_Active_Results.mat', 'Active');
