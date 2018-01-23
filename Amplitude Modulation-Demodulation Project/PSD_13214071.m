%Spesifikasi
Fc=3000; %frekuensi cutoff LPF
Fs=48000; %frekuensi sampling
Wn=2*Fc/Fs; %normalized frekuensi cutoff
n=127; %orde filter
Fc1=8000; %frekuensi carrier 1
Fc2=16000; %frekuensi carrier 2
input_duration=10; %durasi sinyal input dalam detik

%membaca sinyal audio menjadi bentuk vektor matrix
x=audioread('input_1.wav');
y=audioread('input_2.wav');

%mencari koefisien LPF dengan perintah fir1
lpf=fir1(n,Wn,'low');

%pemfilteran sinyal input dengan LPF
x_filtered=filter(lpf,1,x);
y_filtered=filter(lpf,1,y);
audiowrite('x_filtered.wav',x_filtered,Fs);
audiowrite('y_filtered.wav',y_filtered,Fs);

%pembuatan vector matriks t
t0=0;
tf=((input_duration*Fs)-1); 
ti=[t0:1/Fs:tf/Fs]; %jumlah sample adalah sebanyak (durasi inputxfrekuensi sampling) dari t=0 sampai t=durasi input
%penyesuaian ukuran vektor matriks t dengan keluaran filter LPF
tj=ti'; %transpose matriks
t=[tj tj]; %mengubah jumlah kolom matriks t menjadi 2 agar ukurannya sesuai dengan keluaran filter LPF

%membuat sinyal carrier
carrier_sig1=cos(2*pi*Fc1*t);
carrier_sig2=cos(2*pi*Fc2*t);

%proses modulasi (perkalian output LPF dengan sinyal carrier)
modulation1=x_filtered.*carrier_sig1;
modulation2=y_filtered.*carrier_sig2;
audiowrite('modulation1.wav',modulation1,Fs);
audiowrite('modulation2.wav',modulation2,Fs);

result=modulation1+modulation2; %kedua sinyal hasil perkalian dijumlahkan
audiowrite('result.wav',result,Fs);

%proses demodulasi (perkalian hasil sinyal modulasi dengan sinyal carrier)
demodulation1=result.*carrier_sig1;
demodulation2=result.*carrier_sig2;
audiowrite('demodulation1.wav',demodulation1,Fs);
audiowrite('demodulation2.wav',demodulation2,Fs);

%sinyal awal dapat diperoleh dengan melakukan pemfilteran LPF terhadap hasil perkalian
xf=filter(lpf,1,demodulation1);
yf=filter(lpf,1,demodulation2);

%transformasi menjadi bentuk file audio
audiowrite('output_1.wav',xf,Fs);
audiowrite('output_2.wav',yf,Fs);







