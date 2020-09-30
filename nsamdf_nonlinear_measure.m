function [L,s2,sd] = nsamdf_nonlinear_measure(data,fs,winlen,shiftlen,lag,degree,doPlot)
% nsamdf_nonlinear_measure computes the nonlinearity measure L through nsAMDF
% (nonlinear average magnitude difference function), developed by:
%
% Ozkurt et al. (2020), "Identification of nonlinear features in cortical and
% subcortical signals of Parkinson's Disease patients via a novel efficient
% measure", Neuroimage.
%
% Please refer to and cite this paper if you utilize this function in your work.
%
%---INPUTS:
%
% data = One dimensional input time-series (it can be raw, but it is a good idea to low-pass filter it to get rid of high frequency nuisance)
%        For the neural data (LFP, MEG) in the aferomentioned paper, we
%        low-passed the raw data for 40 Hz. The data should be long enough for proper estimation of nonlinearity.
%
% winlen = window length (a long enough segment is important to estimate the nonlinearity)
%          We chose the window length as 14 sec., i.e., winlen = 14*fs
%
% shiftlen = This amounts to window length - overlap length btw windows
%            We chose it as half the window length, i.e., shiftlen = 0.5*winlen
%
% lag = TMaximum lag for nsAMDF, we chose it as 1 sec, i.e., lag = fs.
%
% fs = sampling frequency of the data
%
% degree = The chosen degree p should ideally be large enough to capture the highest order of nonlinearity within the data.
%          We chose p=7 for in our case of Parkinsonian data in the paper.
%
% doPlot = true to plot nsAMDF sequences, otherwise just assign it false
%
%---OUTPUTS:
%
% L: nonlinearity measure
%
% s2: normalized nsAMDF for the degree 2
%
% sd: normalized nsAMDF for the chosen degree greater than 2
%
%
% Required subfunctions are NormedSingleCurveLengthWindowed.m & NormedSingleCurveLength.m
%
%
%   Authored by Tolga Esat Ozkurt, 2020. (tolgaozkurt@gmail.com)


%-------------------------------------------------------------------------------
% Set defaults:

if nargin < 2
    fs = 1;
end
if nargin < 3
    winlen = 14*fs;
end
if nargin < 4
    shiftlen = 0.5*winlen;
end
if nargin < 5
    lag = fs;
end
if nargin < 6
    degree = 7;
end
if nargin < 7
    doPlot = false
end


%-------------------------------------------------------------------------------
s2 = NormedSingleCurveLengthWindowed(data,winlen,shiftlen,lag,fs,2); % nsAMDF for p=2
s2 = s2 ./ max(s2); % normalized

sd = NormedSingleCurveLengthWindowed(data,winlen,shiftlen,lag,fs,degree); % nsAMDF for p=degree
sd = sd ./ max(sd); % normalized

% if you like, you can bandpass filter s2 and sd for the specific frequency band of nonlinear effect
% both to compute L and plot them as such

L = norm(s2 - sd);


if doPlot
    figure
    plot(s2,'b')
    hold on
    plot(sd,'g')
end
