% clear
load Depresion_Prueba.mat

 EEG_data=[];
chanpowr=[]; 
cont_1=0;
cont_2=0;
for i=1:30
    
 cont_1=cont_1+7500;
cont_2=cont_1+7500;

    for l=1:19
%son 19 canales que se van a procesar
EEG_data(l,:)=double(EEG.data(l,cont_1:cont_2));
%tranformada de fourier
s=length(EEG_data(l,:));
nFFT=2;
while nFFT<s
nFFT =nFFT*2;
end
Fs=500;
chanpowr(l,:)=(abs(fft(EEG_data(l,:),nFFT)));
hz=linspace(0,Fs,nFFT);
figure(15);


plot(hz,chanpowr(l,:));

hold on
xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
axis([0 45 -inf 1*10^5])
% set(gca,'xlim',[0 45],'ylim',[0 650])
%legend('p3','p4')
%ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','View Data','Units','normalized','Position',[0.0 0.5 0.4 0.2],,'Visible','on');

  fp1 = uicontrol('Style','radiobutton','String','Fp1');
fp1.Position = [20 450 60 20];
% f3 = uicontrol('Style','radiobutton','String','F3');
% f7 = uicontrol('Style','radiobutton','String','F7');
% c3 = uicontrol('Style','radiobutton','String','C3');
% t7 = uicontrol('Style','radiobutton','String','T7');
% p3 = uicontrol('Style','radiobutton','String','P3');

pause
  
    end


 hold off  

legend('Fp1','F3','F7','C3','T7','P3','P7','O1','Pz','Fp2','Fz','F4','F8','Cz','C4','T8','P4','P8','O2');







% plot todos los canales
% %% delta power
% 
% % Establecemos las bandas in hz
% deltabounds =[0.5 4]';
% 
% % convert to indices
% freqidx =dsearchn(hz',deltabounds); 
% 
% 
% % extraemos la media
% deltapower = mean(chanpowr(:,freqidx(1):freqidx(2)),2);
% 
% % dibujamos por bandas
% figure(16)
% 
% topoplotIndie(deltapower,EEG.chanlocs,'numcontour',0);
% title('Banda delta')
% colorbar 
% % set(gca,'clim',[0 500])
% colormap jet
% 
% 
% %% theta power
% 
% 
% thetabounds =[5 8]';
% 
% 
% freqidx =dsearchn(hz',thetabounds); 
% 
% 
% 
% thetapower = mean(chanpowr(:,freqidx(1):freqidx(2)),2);
% 
% 
% figure(17)
% subplot(2,1,1)
% topoplotIndie(thetapower,EEG.chanlocs,'numcontour',0);
% 
% title('Banda theta')
% colormap jet
% colorbar 
% %%  alpha power
% 
% 
% alphabounds =[8 12]';
% 
% 
% freqidx =dsearchn(hz',alphabounds); 
% 
% 
% 
% alphapower = mean(chanpowr(:,freqidx(1):freqidx(2)),2);
% 
% 
% subplot(2,1,2)
% topoplotIndie(alphapower,EEG.chanlocs,'numcontour',0);
% 
% title('Banda alpha')
% colormap jet
% colorbar 
% %% betha power
% 
% 
% bethabounds =[13 30]';
% 
% 
% freqidx =dsearchn(hz',bethabounds); 
% 
% 
% 
% bethapower = mean(chanpowr(:,freqidx(1):freqidx(2)),2);
% figure(18)
% 
% subplot(2,1,1)
% topoplotIndie(bethapower,EEG.chanlocs,'numcontour',0);
% 
% title('Banda betha')
% colormap jet
% colorbar 
% 
% %% gamma power
% 
% 
% gammabounds =[31 40]';
% 
% % convertir a índices
% freqidx =dsearchn(hz',gammabounds); 
% 
% 
% % extraer potencia media
% gammapower = mean(chanpowr(:,freqidx(1):freqidx(2)),2);
% 
% 
% subplot(2,1,2)
% topoplotIndie(gammapower,EEG.chanlocs,'numcontour',0);
% 
% title('banda gamma')
% colormap jet
% colorbar 
%% banda completa

% límites en hz
banda =[1 45]';

% convertir a índices
freqidx =dsearchn(hz',banda); 


% extraer potencia media
bandapower = mean(chanpowr(:,freqidx(1):freqidx(2)),2);
w_max=[];
f_max=[];
for e=1:19
[w_max(e),f_max(e)]= findpeaks(chanpowr(e,freqidx(1):freqidx(2)),'SortStr' , 'descend' , 'NPeaks' , 1);
peakToFreak(e) = hz(f_max(e));
end
peakToFreak=peakToFreak';
w_max=w_max';
% and plot
figure(69)
topoplotIndie(peakToFreak,EEG.chanlocs,'numcontour',0);
set(gca,'clim',[1 30])
title('banda completa')
colormap jet
colorbar('Ticks',[4,8,13,30],...
         'TickLabels',{'Deltha','Theta','Alpha','Betha'})

pause


end


