clc;

%obtain cosine wave signal
t=0:pi/500:10*pi;
x=cos(t);
x=x(:);%cosine value
sz=size(x,1);
subplot(3,2,1);
title('the desired sine wave signal');
plot(x);
%axis([0 sz -1.1 1.1]);
%obtain cos in frea domain
% xf=fft(x,1024);
% subplot(4,2,2);
% title('the desired sine wave signal in frequency domain');
% plot(abs(xf));
%white noise
z=tf('z',1);
F0=0.5-0.5*z^-1;
w=randn(size(x));
noise=lsim(F0, w);%y0
subplot(3,2,2);
title('the white nosie');
plot(noise);
%noise in freq domain
% wf=fft(noise,1024);
% subplot(4,2,4);
% title('the white nosie in frequency domain');
% plot(abs(wf));
% the primary signal
d=x+noise;
subplot(3,2,3);
title('the primary signal');
plot(d);
% the primary signal in freq domain
% df=fft(d, 1024);
% subplot(4,2,6);
% title('the primary signal in frequency domain');
% plot(abs(df));

%step size
mu=0.00125;
%original coefficients vector
hm_0=[1;1];

[hm,ee]=LMS(mu, hm_0, w, d);
% en = dn - ee
en=d-ee;
subplot(3,2,4);
title('the estimated signal');
plot(en);

title('the filter coefficients');
plot((1:1:5001),hm(1,:));
hold on;
plot((1:1:5001),hm(2,:));


%using stochastic-gradient-descent algorithm
function [hm,ee]=LMS(mu, h0, x, d)
% LMS
% input args:
% mu = the step size
% h0 = original filter coefficients
% x = input signal , whith noise sequence w[n]
% d = desired signal, the primary signal d[n]
% output args:
% hm = filter coefficients in each iterations
% ee = estimated error

% input signal length
N = length(x);

% make sure x and d are column vectos
x=x(:);
d=d(:);

% filter coefficients number
M=size(h0, 1);
hm=zeros(2,1);
ee=zeros(size(x));%adapted output

for n=M:N
    arr=x(n:-1:n-M+1);
    e(n)=d(n)-h0'*arr;
    h0=h0+mu*e(n)*arr;
    hm(1,n)=h0(1);
    hm(2,n)=h0(2);
    ee(n)=h0'*arr;
end

end

