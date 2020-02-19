function [handle,pltchans,epos] = topoplotIndie(Values,chanlocs,varargin)

%% Set defaults

headrad = 0.5;          % radio real de la cabeza - ¡No cambie esto!
GRID_SCALE = 67;        % trazar mapa en una cuadrícula 67X67
CIRCGRID   = 201;       % cantidad de ángulos para usar en dibujar círculos
HEADCOLOR = [0 0 0];    % color de cabeza predeterminado (negro)
HLINEWIDTH = 1.7;         % ancho de línea predeterminado para cabeza, nariz, orejas
BLANKINGRINGWIDTH = .035; % ancho del anillo ciego
HEADRINGWIDTH    = .007;% ancho del anillo de la cabeza de dibujos animados
plotrad = .6;
Values = double(Values);
SHADING = 'interp';
CONTOURNUM = 6;
ELECTRODES = 'labels';

nargs = nargin;
if nargs > 2
    for i = 1:2:length(varargin)
        Param = lower(varargin{i});
        Value = varargin{i+1};
        switch Param
            case 'numcontour'
                CONTOURNUM = Value;
            case 'electrodes'
                ELECTRODES ='labels';
            case 'plotrad'
                plotrad = Value;
            case 'shading'
                SHADING = lower(Value);
                if ~any(strcmp(SHADING,{'flat','interp'}))
                    error('Invalid shading parameter')
                end
        end
    end
end

Values = Values(:); % haciendo columna

%% Read channel location
labels={chanlocs.labels};
Th=[chanlocs.theta];
Rd=[chanlocs.radius];

Th = pi/180*Th;                              % convertir grados a radianes
allchansind = 1:length(Th);
plotchans = 1:length(chanlocs);

%% remove infinite and NaN values

inds = union(find(isnan(Values)), find(isinf(Values))); % NaN and Inf values
for chani=1:length(chanlocs)
    if isempty(chanlocs(chani).X); inds = [inds chani]; end
end

plotchans   = setdiff(plotchans,inds);

[x,y]       = pol2cart(Th,Rd);  % transforma las ubicaciones de los electrodos de coordenadas polares a cartesianas
plotchans   = abs(plotchans);   %polaridades de canal indicadas en reversa 
allchansind = allchansind(plotchans);
Th          = Th(plotchans);
Rd          = Rd(plotchans);
x           = x(plotchans);
y           = y(plotchans);
labels      = char(labels(plotchans)); % remove labels for electrodes without locations
Values      = Values(plotchans);
intrad      = min(1.0,max(Rd)*1.02);             % predeterminado: justo fuera de la ubicación del electrodo más externo
%% Encuentra los canales que se van a dibujar
pltchans = find(Rd <= plotrad); % trazar canales dentro del círculo de trazado
intchans = find(x <= intrad & y <= intrad); % interpolar y trazar canales dentro del cuadrado de interpolación

%% Elimina canales que no son dibujados

allx  = x;
ally  = y;
allchansind = allchansind(pltchans);
intTh = Th(intchans);           %elimina canales justo fuera del área
intRd = Rd(intchans);
intx  = x(intchans);
inty  = y(intchans);
Th    = Th(pltchans);              % eliminate channels outside the plotting area
Rd    = Rd(pltchans);
x     = x(pltchans);
y     = y(pltchans);

intValues = Values(intchans);
Values = Values(pltchans);

labels= labels(pltchans,:);

%% Ubica segun la sequencia de los canales <= headrad
squeezefac = headrad/plotrad;
intRd = intRd*squeezefac; % aprieta las longiutes del circulo del electrodo hacia el vertice
Rd    = Rd*squeezefac;       % apriete las longitudes de arco del electrodo hacia el vértice
% para trazar todo dentro de la cabeza de dibujos animados
intx  = intx*squeezefac;
inty  = inty*squeezefac;
x     = x*squeezefac;
y     = y*squeezefac;
allx  = allx*squeezefac;
ally  = ally*squeezefac;

%% crear un grid
xmin = min(-headrad,min(intx)); xmax = max(headrad,max(intx));
ymin = min(-headrad,min(inty)); ymax = max(headrad,max(inty));
xi   = linspace(xmin,xmax,GRID_SCALE);   % x-axis
yi   = linspace(ymin,ymax,GRID_SCALE);   % y-axis

[Xi,Yi,Zi] = griddata(inty,intx,intValues,yi',xi,'v4'); 

%% Mask out data outside the head
mask = (sqrt(Xi.^2 + Yi.^2) <= headrad); % máscara fuera del círculo de trazado
Zi(mask == 0) = NaN;                  
grid = plotrad;                       
delta = xi(2)-xi(1); % longitud de entrada del grid

%% Scale the axes and make the plot
cla  
hold on
h = gca; 
AXHEADFAC = 1.05;   
set(gca,'Xlim',[-headrad headrad]*AXHEADFAC,'Ylim',[-headrad headrad]*AXHEADFAC);
unsh = (GRID_SCALE+1)/GRID_SCALE; 

if strcmp(SHADING,'interp')
    handle = surface(Xi*unsh,Yi*unsh,zeros(size(Zi)),Zi,'EdgeColor','none','FaceColor',SHADING);
else
    handle = surface(Xi-delta/2,Yi-delta/2,zeros(size(Zi)),Zi,'EdgeColor','none','FaceColor',SHADING);
end
contour(Xi,Yi,Zi,CONTOURNUM,'k','hittest','off');

%% Plot filled ring to mask jagged grid boundary
hwidth = HEADRINGWIDTH;                  
hin  = squeezefac*headrad*(1- hwidth/2); 

if strcmp(SHADING,'interp')
    rwidth = BLANKINGRINGWIDTH*1.3;      
else
    rwidth = BLANKINGRINGWIDTH;         
end
rin    =  headrad*(1-rwidth/2);         
if hin>rin
    rin = hin;                          
end

circ = linspace(0,2*pi,CIRCGRID);
rx = sin(circ);
ry = cos(circ);
ringx = [[rx(:)' rx(1) ]*(rin+rwidth)  [rx(:)' rx(1)]*rin];
ringy = [[ry(:)' ry(1) ]*(rin+rwidth)  [ry(:)' ry(1)]*rin];
ringh = patch(ringx,ringy,0.01*ones(size(ringx)),get(gcf,'color'),'edgecolor','none','hittest','off'); hold on

%% Plot cartoon head, ears, nose
headx = [[rx(:)' rx(1) ]*(hin+hwidth)  [rx(:)' rx(1)]*hin];
heady = [[ry(:)' ry(1) ]*(hin+hwidth)  [ry(:)' ry(1)]*hin];
ringh = patch(headx,heady,ones(size(headx)),HEADCOLOR,'edgecolor',HEADCOLOR,'hittest','off'); hold on

% Plot orejas y nariz
base  = headrad-.0046;
basex = 0.18*headrad;                   % ancho de la nariz
tip   = 1.15*headrad;
tiphw = .04*headrad;                    
tipr  = .01*headrad;                    
q = .04; % ear lengthening
EarX  = [.497-.005  .510  .518  .5299 .5419  .54    .547   .532   .510   .489-.005]; % headrad = 0.5
EarY  = [q+.0555 q+.0775 q+.0783 q+.0746 q+.0555 -.0055 -.0932 -.1313 -.1384 -.1199];
sf    = headrad/plotrad;                                          
% by this factor
plot3([basex;tiphw;0;-tiphw;-basex]*sf,[base;tip-tipr;tip;tip-tipr;base]*sf,2*ones(size([basex;tiphw;0;-tiphw;-basex])),'Color',HEADCOLOR,'LineWidth',HLINEWIDTH,'hittest','off');                 % plot nose
plot3(EarX*sf,EarY*sf,2*ones(size(EarX)),'color',HEADCOLOR,'LineWidth',HLINEWIDTH,'hittest','off')    % plot left ear
plot3(-EarX*sf,EarY*sf,2*ones(size(EarY)),'color',HEADCOLOR,'LineWidth',HLINEWIDTH,'hittest','off')   % plot right ear

%% Mark electrode locations
if strcmp(ELECTRODES,'on')   % plot electrodos como puntos
    hp2 = plot3(y,x,ones(size(x)),'.','Color',[0 0 0],'markersize',5,'linewidth',.5,'hittest','off');
elseif strcmp(ELECTRODES,'labels')  % print nombre de electrodos (labels)
    for i = 1:size(labels,1)
        text(double(y(i)),double(x(i)),1,labels(i,:),'HorizontalAlignment','center','VerticalAlignment','middle','Color',[0 0 0],'hittest','off')
    end
elseif strcmp(ELECTRODES,'numbers')
    for i = 1:size(labels,1)
        text(double(y(i)),double(x(i)),1,int2str(allchansind(i)),'HorizontalAlignment','center','VerticalAlignment','middle','Color',[0 0 0],'hittest','off')
    end
end

epos=[x; y];
axis off
axis equal

