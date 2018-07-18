% This MATLAB program checks the feasibility of LMIs from Proposition 1 of the paper 
% A. Selivanov and E. Fridman, "Delayed point control of a reaction-diffusion PDE 
% under discrete-time point measurements," Automatica, vol. 96, pp. 224-233, 2018. 
a=10;                       % Reaction coefficient 
L=-10;                      % Observer gain
N=10;                       % >=1 Number of indomain sensors 
r=.05;                      % Input delay 
h=.01;                      % Sampling period
etaM=.01;                   % Maximum network-induced delay 
dL=1; dR=0;                 % Boundary conditions 
alpha0=.5;                  % Decay rate 
alpha1=1;                   % Tuning coefficient 
OmegaM=1/N;                 % Maximum subdomain size 

if LMI_Aut18_prop1(a,L,r,h,etaM,dL,dR,alpha0,alpha1,OmegaM)
    disp('Proposition 1: Feasible')
else
    disp('Proposition 1: Not feasible')
end
