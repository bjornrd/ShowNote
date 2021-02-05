% Initial test script to import, play and analyze audio  

clear;

channel_to_analyze = 1;
f_resolution_max = 10; % [Hz]

%% Import 
script_path = mfilepath();
addpath(fullfile(script_path, '..', 'src/'));

audio_filepath    = fullfile(script_path, '..', '..', 'Resources', 'Audio Files', 'C to B single notes.m4a'); 

[y, Fs] = audioread(audio_filepath);

%% Resample
Fs_r = 16e3;
[n,d] = rat(Fs_r/Fs);
y_r = resample(y, n, d);


N_audio_samples = size(y_r, 1);
N_channels      = size(y_r, 2);

% We can create an audioplayer and play the imported file
% player = audioplayer(y, Fs);
% player.play();

%% Set up analysis window
w = createWindow(Fs_r,...
                 'length_t', 50e-3, ...
                 'overlap_percentage', 0.5, ...
                 'window_type', @hamming);

window_length_ms = w.length_t;
window_length_N  = w.length_N;  % Number of samples in the window
window_skip = w.skip_N;


%% Set up time and frequency vector
Nfft = 2^(ceil( log2(Fs_r/2/f_resolution_max) ));
t = 0:1/Fs_r:N_audio_samples/Fs_r;
f = linspace(0, Fs_r/2, Nfft);


%% Loop and analyze the data
% figure(100);
window_pos = 1;
t_sample = [];
i=1;
while window_pos + window_length_N - 1 < N_audio_samples
    t_sample(i) = t(window_pos);
    
    data_to_analyze = y_r(window_pos : window_pos + window_length_N - 1, channel_to_analyze);
    
    [detected_frequencies(i), ~, spect_log(i,:)] = spectralPitchDetector(data_to_analyze, w, Nfft, f);
    
    detected_keys{i} = pitchToKey(detected_frequencies(i), 440);
    window_pos = window_pos + window_skip;
    i=i+1;
end

figure(11);clf;
surf(f(1:end), 1:size(spect_log,1), spect_log)
shading interp
view([90 -90])
axis tight;
title('Spectrum');

figure(22); clf;
plot(t_sample, detected_frequencies);
grid on;
title('Detected Pitch');
