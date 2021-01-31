function w = createWindow(Fs, varargin)
%window_struct = CREATEWINDOW(Fs, ...)

p = inputParser();

p.addOptional('length_t',           100e-3, @mustBeNonnegative);
p.addOptional('overlap_percentage', 0.5,    @(x)isBetween(x, 0, 1) );
p.addOptional('window_type', @hamming);

p.parse(varargin{:});

w.length_t              = p.Results.length_t;
w.overlap_percentage    = p.Results.overlap_percentage;
w.window_type           = p.Results.window_type;

w.length_N = round(Fs * w.length_t);
w.skip_N = round(w.length_N * (1.0 - w.overlap_percentage));

w.window = w.window_type(w.length_N);

end

function q = isBetween(x, a, b)
    q = x < b && x > a;
end
