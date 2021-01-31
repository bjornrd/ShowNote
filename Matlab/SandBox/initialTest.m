% Initial test script to import, play and analyze audio  

channel_to_analyze = 1;


%% Import 
script_path = mfilepath();
filepath     = fullfile(script_path, '..', '..', 'Resources', 'Audio Files', 'C to B single notes.m4a'); 

[y, Fs] = audioread(filepath);

N_audio_samples = length(y);
N_channels      = size(y, 2);

% We can create an audioplayer and play the imported file
% player = audioplayer(y, Fs);
% player.play();

%% Set up analysis window
Fms = Fs/1e3; % Sampling frequency relative to miliseconds (samples per milisecond)

window_length_ms = 50;  % Window length in miliseconds
window_length_N  = round(Fms*window_length_ms);  % Number of samples in the window

window_overlap_percentage = 0.5;
window_skip = round( window_length_N*window_overlap_percentage );

window_pos = 1;

%% Set up time and frequency vector
Nfft = 2^13;
t = 0:1/Fs:N_audio_samples/Fs;
f = linspace(0, Fs/2, Nfft);

%% Hamming smoothing window
w = hamming(window_length_N);


%% Loop and analyze the data
% figure(1);
i=1;
while window_pos + window_length_N - 1 < N_audio_samples
    
    data_to_analyze = y(window_pos : window_pos + window_length_N - 1, channel_to_analyze);
    
    spect = fftshift(fft(w.*data_to_analyze, Nfft*2));
    spect_log(i,:) = 20*log10(abs(spect(Nfft+1:end-Nfft*3/4))+eps);

    
    window_pos = window_pos + window_skip;
    i=i+1;
end

figure;surf(f(1:end-Nfft*3/4), 1:size(spect_log,1), spect_log)
shading interp
view([90 -90])
