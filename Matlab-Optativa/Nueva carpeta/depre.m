function varargout = depre(varargin)
% DEPRE MATLAB code for depre.fig
%      DEPRE, by itself, creates a new DEPRE or raises the existing
%      singleton*.
%
%      H = DEPRE returns the handle to a new DEPRE or the handle to
%      the existing singleton*.
%
%      DEPRE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEPRE.M with the given input arguments.
%
%      DEPRE('Property','Value',...) creates a new DEPRE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before depre_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to depre_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help depre

% Last Modified by GUIDE v2.5 18-Feb-2020 21:31:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @depre_OpeningFcn, ...
                   'gui_OutputFcn',  @depre_OutputFcn, ...
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


% --- Executes just before depre is made visible.
function depre_OpeningFcn(hObject, eventdata, handles, varargin)
%clc
%clear all
%close all
global dato
global data
global bandas
global Fs
global val
global val2
global tiempomatriz;
global senialtiempo1;
global senialtiempo2;
global pxx1matriz;
global pxx2matriz;
global contadorPrincipal;
global p1
global p2
global p3
global p4
global p5
global f1
global f2
global f3
global f4
global f5
global p2p1
global p2p2
global p2p3
global p2p4
global p2p5
global frecuencia1matriz
global frecuencia2matriz
contadorPrincipal=1;
dato=load('558_Depression_REST.mat');
data=[];
%Bandas de frecuencia
bandas=[];
%canales a analizar
p=[1 3 6 8 10 12 14 24 26 28 30 32 44 46 48 50 52 61 63];
q=['Fp1','Fp2','F7','F3','Fz','F4','F8','T7','C3','Cz','C4','T8','P7','P3','Pz','P4','P8','O1','O2'];
Fs=500;
% handles.dato = dato.EEG.data;
% handles.p = p;
% handles.q = q;
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes depre wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = depre_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
global val
global val2
val = get(hObject,'value');
p=[1 3 6 8 10 12 14 24 26 28 30 32 44 46 48 50 52 61 63];

%%
% if val==1
    h=p(val);
    h1=p(val2);
    global dato
    global Fs
    global tiempomatriz;
    global pxx1matriz;
    global pxx2matriz
    global senialtiempo1;
    global senialtiempo2;
    senialtiempo1=[];
    senialtiempo2=[];
    tiempomatriz=[];
    pxx1matriz=[]     ;
    pxx2matriz=[];
    global p1
global p2
global p3
global p4
global p5
global f1
global f2
global f3
global f4
global f5
global p2p1
global p2p2
global p2p3
global p2p4
global p2p5
p1=[];
p2=[];
p3=[];
p4=[];
p5=[];
f1=[];
f2=[];
f3=[];
f4=[];
f5=[];
p2p1=[];
p2p2=[];
p2p3=[];
p2p4=[];
p2p5=[];

global frecuencia1matriz
global frecuencia2matriz
frecuencia1matriz={};
frecuencia2matriz={};
    datos11=double((dato.EEG.data((h),:)));
    datos21=double((dato.EEG.data((h1),:))); 
    
    
    
    
    t=(0:(length(datos11)-1))/Fs;
    contm=1;
    tiemposalto=15*Fs
    for j=1:tiemposalto:length(datos11)-tiemposalto-1
    datos1=datos11((j):(j+tiemposalto));
    datos2=datos21((j):(j+tiemposalto));

    %normalizacion1
    %     maximo=max(datos1);
%     datos1=datos1./maximo;
%     maximo2=max(datos2);
%     datos2=datos2./maximo2;
    
    %normalizacion2
% a1 = min(datos1);
% c1 = max(datos1);
% x1 = 0;
% z1 = 1;
% 
% for i=1:length(datos1)
% datos1(i) = (datos1(i) - a1) * (z1 - x1) / (c1 - a1) + x1;
% end
%    
%    a1 = min(datos2);
% c1 = max(datos2);
% x1 = 0;
% z1 = 1;
% 
% for i=1:length(datos2)
% datos2(i) = (datos2(i) - a1) * (z1 - x1) / (c1 - a1) + x1;
% end





%     
    senialtiempo1(contm,:)=datos1;
    senialtiempo2(contm,:)=datos2;
    window_1=hanning(length(datos1/2));
    s=length(datos1);
    y_enventanado=datos1.*window_1';
    y2_enventanado=datos2.*window_1';
    nFFT=2;
    while nFFT<s
    nFFT =nFFT*2;
    end
    noverlap=((length(datos1)/2));

%Con fft
    pxx=(abs(fft(datos1,nFFT)));
    pxx2=(abs(fft(datos2,nFFT)));
    
    tiempomatriz(contm,:)=t((j):(j+tiemposalto));
    pxx1matriz(contm,:)=pxx;
    pxx2matriz(contm,:)=pxx2;

        t_2=linspace(0,Fs,nFFT);
    t_3=[];
  for p=1:length(t_2)
    
     if ((t_2(p)>=1) && (t_2(p)<=45))
         t_3(1,p)=t_2(p);
         s_1(1,p)=pxx(p);
         
     end
  end
  
  
  for p=1:length(t_2)
    
     if ((t_2(p)>=1) && (t_2(p)<=45))
    %    t_3(1,p)=t_2(p);
         s_2(1,p)=pxx2(p);
         
     end
  end
  
  
  
    [pk1, lc1] = findpeaks(s_1, 'SortStr' , 'descend' , 'NPeaks' , 1);
P1peakFreqs = t_3(lc1);
 

    if((P1peakFreqs>=1) && ((P1peakFreqs<4)))
    frequency='deltha';
    end
    
    
    if(((P1peakFreqs)>=4) && ((P1peakFreqs<8)))
   frequency='theta';
    
    end
    
    if((P1peakFreqs)>=8 && (P1peakFreqs<14))      
    frequency='alpha';
    end
    
    if((P1peakFreqs)>=14 && (P1peakFreqs<=30))
    
    frequency='betha';
    end    
    
    
    if((P1peakFreqs)>30 && (P1peakFreqs<=45))
     frequency='gamma';
    end    
    set(handles.edit3,'string',frequency);
   
    
       [pk2, lc2] = findpeaks(s_2, 'SortStr' , 'descend' , 'NPeaks' , 1);
P1peakFreqs_2 = t_3(lc2);
 
    if((P1peakFreqs_2>=0.5) && ((P1peakFreqs_2<4)))
        
    frequency_2='deltha';
    end
    
    
    if(((P1peakFreqs_2)>=4) && ((P1peakFreqs_2<8)))
   frequency_2='theta';
    
    end
    
    if((P1peakFreqs_2)>=8 && (P1peakFreqs_2<14))      
    frequency_2='alpha';
    end
    
    if((P1peakFreqs_2)>=14 && (P1peakFreqs_2<=30))
    
    frequency_2='betha';
    end    
    
    
    if((P1peakFreqs_2)>30 && (P1peakFreqs_2<=45))
     frequency_2='gamma';
    end    
    
        set(handles.edit4,'string',frequency_2);
        
    
        frecuencia1matriz{contm}=frequency;
    frecuencia2matriz{contm}=frequency_2;
        
        
    t_2=linspace(0,Fs,nFFT);
    lonv=fix(length(pxx)/10);
    overl=fix(lonv/2);

    tiempo_1=[];
    tiempo_2=[];
    tiempo_3=[];
    tiempo_4=[];
    tiempo_5=[];
    acum_1=1;
    acum_2=1;
    acum_3=1;
    acum_4=1;
    acum_5=1;
    pxx_1=[];
    pxx_2=[];
    pxx_3=[];
    pxx_4=[];
    pxx_5=[];

    
    pxx2_1=[];
    pxx2_2=[];
    pxx2_3=[];
    pxx2_4=[];
    pxx2_5=[];
    for s=1:(length(pxx))
        
    if(((t_2(s))>=0.5) && ((t_2(s)<4)))
    tiempo_1(1,acum_1)=t_2(s);
    %almacenar matriz
    pxx_1(1,acum_1)=pxx(s);
    pxx2_1(1,acum_1)=pxx2(s);
    bandas(acum_1,1)=pxx(s);
    acum_1=acum_1+1;    
    
    end
    
    
    if(((t_2(s))>=4) && ((t_2(s)<8)))
    tiempo_2(1,acum_2)=t_2(s);
    pxx_2(1,acum_2)=pxx(s);
    pxx2_2(1,acum_2)=pxx2(s);
    bandas(acum_2,2)=pxx(s);
    acum_2=acum_2+1;
    
    end
    
    if((t_2(s))>=8 && (t_2(s)<14))      
    tiempo_3(1,acum_3)=t_2(s);
    pxx_3(1,acum_3)=pxx(s);
    pxx2_3(1,acum_3)=pxx2(s);
    bandas(acum_3,3)=pxx(s);
    acum_3=acum_3+1;
    
    end
    
    if((t_2(s))>=14 && (t_2(s)<=30))
    tiempo_4(1,acum_4)=t_2(s);
    pxx_4(1,acum_4)=pxx(s);
    pxx2_4(1,acum_4)=pxx2(s);
    bandas(acum_4,4)=pxx(s);
    acum_4=acum_4+1;
    
    end    
    
    
    if((t_2(s))>30 && (t_2(s)<=45))
    tiempo_5(1,acum_5)=t_2(s);
    pxx_5(1,acum_5)=pxx(s);
    pxx2_5(1,acum_5)=pxx2(s);
    bandas(acum_5,5)=pxx(s);
    acum_5=acum_5+1;
    
    end    
    end
    p1(contm,:)=pxx_1;
    p2p1(contm,:)=pxx2_1;
    f1(contm,:)=tiempo_1;
    p2(contm,:)=pxx_2;
    p2p2(contm,:)=pxx2_2;
    f2(contm,:)=tiempo_2;
    p3(contm,:)=pxx_3;
    p2p3(contm,:)=pxx2_3;
    f3(contm,:)=tiempo_3;
    p4(contm,:)=pxx_4;
    p2p4(contm,:)=pxx2_4;
    f4(contm,:)=tiempo_4;
    p5(contm,:)=pxx_5;
    p2p5(contm,:)=pxx2_5;
    f5(contm,:)=tiempo_5;
    contm=contm+1;
    end
   
   
function popupmenu2_Callback(hObject, eventdata, handles)
global val
global val2
val2 = get(hObject,'value');



p=[1 3 6 8 10 12 14 24 26 28 30 32 44 46 48 50 52 61 63];

    h=p(val);
     h1=p(val2);
     global dato
    global Fs
    global tiempomatriz;
    global pxx1matriz;
    global pxx2matriz
    global senialtiempo1;
    global senialtiempo2;
    senialtiempo1=[];
    senialtiempo2=[];
    tiempomatriz=[];
    pxx1matriz=[]     ;
    pxx2matriz=[];
    global p1
global p2
global p3
global p4
global p5
global f1
global f2
global f3
global f4
global f5
global p2p1
global p2p2
global p2p3
global p2p4
global p2p5
p1=[];
p2=[];
p3=[];
p4=[];
p5=[];
f1=[];
f2=[];
f3=[];
f4=[];
f5=[];
p2p1=[];
p2p2=[];
p2p3=[];
p2p4=[];
p2p5=[];
global frecuencia1matriz
global frecuencia2matriz
frecuencia1matriz={};
frecuencia2matriz={};

    datos11=double((dato.EEG.data((h),:)));
    datos21=double((dato.EEG.data((h1),:))); 
    t=(0:(length(datos11)-1))/Fs;
    contm=1;
    tiemposalto=15*Fs
    for j=1:tiemposalto:length(datos11)-tiemposalto-1
    datos1=datos11((j):(j+tiemposalto));
    datos2=datos21((j):(j+tiemposalto));
    %normalizacion1
%     maximo=max(datos1);
%     datos1=datos1./maximo;
%     maximo2=max(datos2);
%     datos2=datos2./maximo2;
     %normalizacion2
% a1 = min(datos1);
% c1 = max(datos1);
% x1 = 0;
% z1 = 1;
% 
% for i=1:length(datos1)
% datos1(i) = (datos1(i) - a1) * (z1 - x1) / (c1 - a1) + x1;
% end
%    
%    a1 = min(datos2);
% c1 = max(datos2);
% x1 = 0;
% z1 = 1;
% 
% for i=1:length(datos2)
% datos2(i) = (datos2(i) - a1) * (z1 - x1) / (c1 - a1) + x1;
% end

    
    
    senialtiempo1(contm,:)=datos1;
    senialtiempo2(contm,:)=datos2;
    window_1=hanning(length(datos1/2));
    s=length(datos1);
    y_enventanado=datos1.*window_1';
    y2_enventanado=datos2.*window_1';
    nFFT=2;
    while nFFT<s
    nFFT =nFFT*2;
    end
    noverlap=((length(datos1)/2));
    pxx=(abs(fft(datos1,nFFT)));
    pxx2=(abs(fft(datos2,nFFT)));
    
    tiempomatriz(contm,:)=t((j):(j+tiemposalto));
    pxx1matriz(contm,:)=pxx;
    pxx2matriz(contm,:)=pxx2;
    
        t_2=linspace(0,Fs,nFFT);
    t_3=[];
  for p=1:length(t_2)
    
     if ((t_2(p)>=1) && (t_2(p)<=45))
         t_3(1,p)=t_2(p);
         s_1(1,p)=pxx(p);
         
     end
  end
  
  
  for p=1:length(t_2)
    
     if ((t_2(p)>=1) && (t_2(p)<=45))
    %    t_3(1,p)=t_2(p);
         s_2(1,p)=pxx2(p);
         
     end
  end
  
  
  
    [pk1, lc1] = findpeaks(s_1, 'SortStr' , 'descend' , 'NPeaks' , 1);
P1peakFreqs = t_3(lc1);
 

    if((P1peakFreqs>=1) && ((P1peakFreqs<4)))
    frequency='deltha';
    end
    
    
    if(((P1peakFreqs)>=4) && ((P1peakFreqs<8)))
   frequency='theta';
    
    end
    
    if((P1peakFreqs)>=8 && (P1peakFreqs<14))      
    frequency='alpha';
    end
    
    if((P1peakFreqs)>=14 && (P1peakFreqs<=30))
    
    frequency='betha';
    end    
    
    
    if((P1peakFreqs)>30 && (P1peakFreqs<=45))
     frequency='gamma';
    end    
    set(handles.edit3,'string',frequency);
   
    
       [pk2, lc2] = findpeaks(s_2, 'SortStr' , 'descend' , 'NPeaks' , 1);
P1peakFreqs_2 = t_3(lc2);
 
    if((P1peakFreqs_2>=0.5) && ((P1peakFreqs_2<4)))
        
    frequency_2='deltha';
    end
    
    
    if(((P1peakFreqs_2)>=4) && ((P1peakFreqs_2<8)))
   frequency_2='theta';
    
    end
    
    if((P1peakFreqs_2)>=8 && (P1peakFreqs_2<14))      
    frequency_2='alpha';
    end
    
    if((P1peakFreqs_2)>=14 && (P1peakFreqs_2<=30))
    
    frequency_2='betha';
    end    
    
    
    if((P1peakFreqs_2)>30 && (P1peakFreqs_2<=45))
     frequency_2='gamma';
    end    
    
        set(handles.edit4,'string',frequency_2);
    
    frecuencia1matriz{contm}=frequency;
    frecuencia2matriz{contm}=frequency_2;
    
    
    
    t_2=linspace(0,Fs,nFFT);
    lonv=fix(length(pxx)/10);
    overl=fix(lonv/2);

    tiempo_1=[];
    tiempo_2=[];
    tiempo_3=[];
    tiempo_4=[];
    tiempo_5=[];
    acum_1=1;
    acum_2=1;
    acum_3=1;
    acum_4=1;
    acum_5=1;
    pxx_1=[];
    pxx_2=[];
    pxx_3=[];
    pxx_4=[];
    pxx_5=[];

    
    pxx2_1=[];
    pxx2_2=[];
    pxx2_3=[];
    pxx2_4=[];
    pxx2_5=[];
    for s=1:(length(pxx))
        
    if(((t_2(s))>=0.5) && ((t_2(s)<4)))
    tiempo_1(1,acum_1)=t_2(s);
    %almacenar matriz
    pxx_1(1,acum_1)=pxx(s);
    pxx2_1(1,acum_1)=pxx2(s);
    bandas(acum_1,1)=pxx(s);
    acum_1=acum_1+1;    
    
    end
    
    
    if(((t_2(s))>=4) && ((t_2(s)<8)))
    tiempo_2(1,acum_2)=t_2(s);
    pxx_2(1,acum_2)=pxx(s);
    pxx2_2(1,acum_2)=pxx2(s);
    bandas(acum_2,2)=pxx(s);
    acum_2=acum_2+1;
    
    end
    
    if((t_2(s))>=8 && (t_2(s)<14))      
    tiempo_3(1,acum_3)=t_2(s);
    pxx_3(1,acum_3)=pxx(s);
    pxx2_3(1,acum_3)=pxx2(s);
    bandas(acum_3,3)=pxx(s);
    acum_3=acum_3+1;
    
    end
    
    if((t_2(s))>=14 && (t_2(s)<=30))
    tiempo_4(1,acum_4)=t_2(s);
    pxx_4(1,acum_4)=pxx(s);
    pxx2_4(1,acum_4)=pxx2(s);
    bandas(acum_4,4)=pxx(s);
    acum_4=acum_4+1;
    
    end    
    
    
    if((t_2(s))>30 && (t_2(s)<=45))
    tiempo_5(1,acum_5)=t_2(s);
    pxx_5(1,acum_5)=pxx(s);
    pxx2_5(1,acum_5)=pxx2(s);
    bandas(acum_5,5)=pxx(s);
    acum_5=acum_5+1;
    
    end    
    end
    p1(contm,:)=pxx_1;
    p2p1(contm,:)=pxx2_1;
    f1(contm,:)=tiempo_1;
    p2(contm,:)=pxx_2;
    p2p2(contm,:)=pxx2_2;
    f2(contm,:)=tiempo_2;
    p3(contm,:)=pxx_3;
    p2p3(contm,:)=pxx2_3;
    f3(contm,:)=tiempo_3;
    p4(contm,:)=pxx_4;
    p2p4(contm,:)=pxx2_4;
    f4(contm,:)=tiempo_4;
    p5(contm,:)=pxx_5;
    p2p5(contm,:)=pxx2_5;
    f5(contm,:)=tiempo_5;
    contm=contm+1;

    end

    
   


% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
close
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in popupmenu2.


% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global tiempomatriz;
    global pxx1matriz;
    global pxx2matriz;
    global contadorPrincipal;
    global senialtiempo1;
    global senialtiempo2;
    global p1
global p2
global p3
global p4
global p5
global f1
global f2
global f3
global f4
global f5
global p2p1
global p2p2
global p2p3
global p2p4
global p2p5
    if contadorPrincipal<length(pxx1matriz(:,1))-1
    axes(handles.axes1);
    plot(tiempomatriz(contadorPrincipal,:),senialtiempo1(contadorPrincipal,:));
     hold on
    plot(tiempomatriz(contadorPrincipal,:),senialtiempo2(contadorPrincipal,:));
    hold off
    axes(handles.axes4);
%     plot(pxx1matriz(contadorPrincipal,:));
%    hold on
%    plot(pxx2matriz(contadorPrincipal,:));
%    hold off
%    contadorPrincipal=contadorPrincipal+1;
plot(f1(contadorPrincipal,:),p1(contadorPrincipal,:),f2(contadorPrincipal,:),p2(contadorPrincipal,:),f3(contadorPrincipal,:),p3(contadorPrincipal,:),f4(contadorPrincipal,:),p4(contadorPrincipal,:),f5(contadorPrincipal,:),p5(contadorPrincipal,:));
   hold on
   plot(f1(contadorPrincipal,:),p2p1(contadorPrincipal,:),f2(contadorPrincipal,:),p2p2(contadorPrincipal,:),f3(contadorPrincipal,:),p2p3(contadorPrincipal,:),f4(contadorPrincipal,:),p2p4(contadorPrincipal,:),f5(contadorPrincipal,:),p2p5(contadorPrincipal,:));
   hold off
   [R,P]=corrcoef(pxx1matriz(contadorPrincipal,:),pxx2matriz(contadorPrincipal,:));
    set(handles.edit1,'string',R(1,2));
    a2=cov(pxx1matriz(contadorPrincipal,:),pxx2matriz(contadorPrincipal,:));
    set(handles.edit2,'string',a2(1,2));
   
   global frecuencia1matriz
   global frecuencia2matriz
   set(handles.edit3,'string',frecuencia1matriz{contadorPrincipal});
   set(handles.edit4,'string',frecuencia2matriz{contadorPrincipal});
   
   
   if (contadorPrincipal>0 && contadorPrincipal+1<length(pxx1matriz(:,1))-1)
   contadorPrincipal=contadorPrincipal+1;
   contadorPrincipal
   end
    end
    
    
    
    
    

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global tiempomatriz;
    global pxx1matriz;
    global pxx2matriz;
    global contadorPrincipal;
    global senialtiempo1;
    global senialtiempo2;
    global p1
global p2
global p3
global p4
global p5
global f1
global f2
global f3
global f4
global f5
global p2p1
global p2p2
global p2p3
global p2p4
global p2p5
    if contadorPrincipal>=1
    axes(handles.axes1);
    plot(tiempomatriz(contadorPrincipal,:),senialtiempo1(contadorPrincipal,:));
     hold on
    plot(tiempomatriz(contadorPrincipal,:),senialtiempo2(contadorPrincipal,:));
    hold off
    axes(handles.axes4);
%     plot(pxx1matriz(contadorPrincipal,:));
%    hold on
%    plot(pxx2matriz(contadorPrincipal,:));
%    hold off
plot(f1(contadorPrincipal,:),p1(contadorPrincipal,:),f2(contadorPrincipal,:),p2(contadorPrincipal,:),f3(contadorPrincipal,:),p3(contadorPrincipal,:),f4(contadorPrincipal,:),p4(contadorPrincipal,:),f5(contadorPrincipal,:),p5(contadorPrincipal,:));
   hold on
   plot(f1(contadorPrincipal,:),p2p1(contadorPrincipal,:),f2(contadorPrincipal,:),p2p2(contadorPrincipal,:),f3(contadorPrincipal,:),p2p3(contadorPrincipal,:),f4(contadorPrincipal,:),p2p4(contadorPrincipal,:),f5(contadorPrincipal,:),p2p5(contadorPrincipal,:));
   hold off
   
   
   [R,P]=corrcoef(pxx1matriz(contadorPrincipal,:),pxx2matriz(contadorPrincipal,:));
    set(handles.edit1,'string',R(1,2));
    a2=cov(pxx1matriz(contadorPrincipal,:),pxx2matriz(contadorPrincipal,:));
    set(handles.edit2,'string',a2(1,2));
   
   global frecuencia1matriz
   global frecuencia2matriz
   set(handles.edit3,'string',frecuencia1matriz{contadorPrincipal});
   set(handles.edit4,'string',frecuencia2matriz{contadorPrincipal});
%    axes(handles.axes6);
%    global dato
%    medianasEEG=mean(dato.EEG.data')
%    medianasEEG=medianasEEG(1:64)
%    canales=dato.EEG.chanlocs
%    canal1=canales(1,1:59)
%    canal2=canales(1,61:63)
%    canal3=canales(1,65:66)
%    
%    canales={canal1 canal2 canal3}
%    
%    
%    topoplotIndie(medianasEEG,canales)
    if (contadorPrincipal-1>0 && contadorPrincipal-1<length(pxx1matriz(:,1)))
   contadorPrincipal=contadorPrincipal-1;
   contadorPrincipal
    end
    end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
depre

