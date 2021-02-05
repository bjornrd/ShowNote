function [detected_pitch, spectrum, log_spectrum] = spectralPitchDetector(data, window_struct, Nfft, frequency_table)
%[detected_pitch, spectrum, log_spectrum] = SPECTRALPITCHDETECTOR(data, window_struct, Nfft) Estimate pitch based on the spectrum of the data

w = window_struct;

spectrum = fftshift( fft( w.window.*data, Nfft*2));  %Nfft*2 since we're only keeping half the spectral data and want to keep the resolution
log_spectrum = 20*log10(abs(spectrum(Nfft+1:end))+eps);

current_spect = movmean(log_spectrum, 5);

warning off;
[~, curr_freq] = findpeaks(current_spect, 'NPeaks', 1, 'MinPeakHeight', -10);

if isempty(curr_freq)
    detected_pitch = 0;
else
    detected_pitch = frequency_table(curr_freq);
end

end

