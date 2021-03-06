function estima3(m,c,cf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cf is optional argument, intended to be used only to perform a 
% pseudo-conterfactual analisys. It is restricted to the configuration
% of model 1. First, I want to make sure that it will only be used for that
% purpose, therefore, I set a default value for cf = 0, meaning that it
% will only perform the counterfactual analysis if it is the user desire.
% for any other value different from zero, the function will estimate the
% model for the counterfactual analisys.
if nargin > 2
    cf = cf;
else
    cf = 0;
end

if cf ~= 0              % Perform the "pseudo-counterfactual" analisys
    if m == 1
        % Calling routine that estimate counterfactual model
        counterfactual
    else
        error('Counterfactual analysis restricted to the benchmark model. See readme.');
    end
else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this function automatize the estimation routine
% m determines which model will be estimated
% 1 = Benchmark, 2 = Only PCOM,3 = Only WGDP, 4 = Only VIX,
% 5 = WGDP + PCOM, 6 = VIX + PCOM, 7 = WGDP + VIX, 8 = No block recursion
% 9 = WGDP PCOM VIX
% c determines which country's data will be used
% 1 = Brazil, 2 = Chile, 3 = Colombia, 4 = Peru

% checking if function's argument is ok
if m > 9 || m < 0
    error('Error. The first argument of this function is only defined for values between 0 and 9, inclusive. See Readme.');
elseif c > 4 || c < 0
    error('Error! The second argument of this function is only defined for values between 0 and 4, inclusive. See Readme.');
end

% setting the apropriate model file for estimation
if m == 1
    model = 'ftd_cholesky';     % Function that imposes contemporaneous and
elseif m == 2                   % lag restrictions on each model
    model = 'ftd_cholesky2';
elseif m == 3 || m == 5 || m == 6
    model = 'ftd_cholesky3';
elseif m == 4 || m == 7 || m == 8
    model = 'ftd_cholesky4';
elseif m == 9
    model = 'ftd_cholesky9';
end

% routines needed to estimate the model
which_country = c; % this variable is used in msstart_setup
msstart_setup      % file that make all appropriate settings for estimation
msprob             % estimation 
msprobg            % obtain error bands
close all
irfs               % obtain IRF matrix
fevd               % perform forecast error variance decomposition
end

