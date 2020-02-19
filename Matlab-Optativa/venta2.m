function varargout = venta2(varargin)
% VENTA2 MATLAB code for venta2.fig
%      VENTA2, by itself, creates a new VENTA2 or raises the existing
%      singleton*.
%
%      H = VENTA2 returns the handle to a new VENTA2 or the handle to
%      the existing singleton*.
%
%      VENTA2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VENTA2.M with the given input arguments.
%
%      VENTA2('Property','Value',...) creates a new VENTA2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before venta2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to venta2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help venta2

% Last Modified by GUIDE v2.5 18-Feb-2020 23:26:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @venta2_OpeningFcn, ...
                   'gui_OutputFcn',  @venta2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before venta2 is made visible.
function venta2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to venta2 (see VARARGIN)

% Choose default command line output for venta2
global dato
global contadorTiempo
global vectortiempo
dato=load('Depresion_Prueba.mat');
contadorTiempo=0;
Fs=500;
longitud =length(double(dato.EEG.data(1,:)))
vectortiempo=(0:longitud)/Fs;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes venta2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = venta2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dato 
EEG_data=[];
EEG_tiempo=[];
chanpowr=[]; 
Fs=500;
global contadorTiempo
global vectortiempo
for l=1:19
EEG_data(l,:)=double(dato.EEG.data(l,(contadorTiempo*15*Fs)+1:(contadorTiempo+1)*15*Fs));
EEG_tiempo(l,:)=vectortiempo((contadorTiempo*15*Fs)+1:(contadorTiempo+1)*15*Fs);
s=length(EEG_data(l,:));
nFFT=2;
while nFFT<s
nFFT =nFFT*2;
end

chanpowr(l,:)=(abs(fft(EEG_data(l,:),nFFT)));
hz=linspace(0,Fs,nFFT);
 end
 
banda =[1 45]';
freqidx =dsearchn(hz',banda); 
w_max=[];
f_max=[];
for e=1:19
[w_max(e),f_max(e)]= findpeaks(chanpowr(e,freqidx(1):freqidx(2)),'SortStr' , 'descend' , 'NPeaks' , 1);
peakToFreak(e) = hz(f_max(e));
end
peakToFreak=peakToFreak';
axes(handles.axes3);
plot(EEG_tiempo(1,:),EEG_data(1,:));
xlabel('Time (s)'), ylabel('Voltage(\muV)')

axes(handles.axes1);
plot(hz,chanpowr(1,:));
xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
axis([0 45 -inf 1*10^5])
legend('Fp1','F3','F7','C3','T7','P3','P7','O1','Pz','Fp2','Fz','F4','F8','Cz','C4','T8','P4','P8','O2');

  
axes(handles.axes2);
topoplotIndie(peakToFreak,dato.EEG.chanlocs,'numcontour',0);
set(gca,'clim',[1 30])
title('banda completa')
colormap jet
colorbar('Ticks',[4,8,13,30],...
         'TickLabels',{'Deltha','Theta','Alpha','Betha'})



contadorTiempo=contadorTiempo+1
