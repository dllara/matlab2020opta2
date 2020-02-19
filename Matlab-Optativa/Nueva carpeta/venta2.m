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

% Last Modified by GUIDE v2.5 18-Feb-2020 23:42:58

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
global valormenu1
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
global valormenu1
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



valormenu1=get(handles.popupmenu1,'value')
if valormenu1==1  
    titulo='banda completa';
banda =[1 45]';
end
if valormenu1==2  
    titulo='banda delta';
banda =[0.5 4]';
end
if valormenu1==3  
    titulo='banda tetha';
banda =[4 8]';
end
if valormenu1==4
    titulo='banda alpha';
banda =[8 13]';
end
if valormenu1==5  
    titulo='banda betha';
banda =[13 30]';
end
if valormenu1==6  
    titulo='banda gamma';
banda =[30 40]';
end
freqidx =dsearchn(hz',banda); 
w_max=[];
f_max=[];




if valormenu1==1  
for e=1:19
[w_max(e),f_max(e)]= findpeaks(chanpowr(e,freqidx(1):freqidx(2)),'SortStr' , 'descend' , 'NPeaks' , 1);
peakToFreak(e) = hz(f_max(e));
peakToFreak=peakToFreak';
end
else
    peakToFreak=mean(chanpowr(:,freqidx(1):freqidx(2)),2);
end




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

if valormenu1==1  
   set(gca,'clim',[1 30])
else
    set(gca,'clim',[min(peakToFreak) max(peakToFreak)])
end




title(titulo)
colormap jet

if valormenu1==1
colorbar('Ticks',[4,8,13,30],...
         'TickLabels',{'Deltha','Theta','Alpha','Betha'})
else
    colorbar
end



contadorTiempo=contadorTiempo+1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global valormenu1
valormenu1 = get(hObject,'value');

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
