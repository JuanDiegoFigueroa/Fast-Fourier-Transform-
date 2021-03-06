function varargout = Transformada_hipocicloides(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Transformada_hipocicloides_OpeningFcn, ...
                   'gui_OutputFcn',  @Transformada_hipocicloides_OutputFcn, ...
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


% --- Executes just before Transformada_hipocicloides is made visible.
function Transformada_hipocicloides_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Transformada_hipocicloides (see VARARGIN)

% Choose default command line output for Transformada_hipocicloides
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Transformada_hipocicloides wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Transformada_hipocicloides_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in k.
function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns k contents as cell array
%        contents{get(hObject,'Value')} returns selected item from k



%|||||||||||||||||||||||||Explicaci??n del c??digo||||||||||||||||||||||||||%

r = 1; % Se define el radio menor
t = linspace(0,2*pi,10000); % Se define el par??metro que va a ser el ??ngulo entre 0 y 2pi con 10k datos
pos = get(handles.k, 'Value');  %Se obtienen los valores de posici??n del popupmenu
sarta = get(handles.k, 'string'); %Toma los strings del popupmenu
k = str2num(sarta{pos}); %Cambia el valor del string a numero
Rc = k*r; % Se define el valor del radio grande en funci?n del valor de k

% Se parametriza la ecuaci??n del hipocicloide y se centra
x = ((Rc)-r)*cos(t) + r*cos(t*(((Rc)-r)/r)) + 256; 
y = ((Rc)-r)*sin(t) - r*sin(t*(((Rc)-r)/r)) + 256;

% Se parametriza la ecuaci??n de la circunferencia y se centra
x1=(Rc)*cos(t) + 256;
y1=(Rc)*sin(t) + 256;

%Las ecuaciones param??tricas anteriores se convierten a imagen binaria
bw1 = ~poly2mask(x,y,512,512);
bw2 = poly2mask(x1,y1,512,512);

%Se realiza el and para ambas imagenes binarias para tomar la intesecci??n
%entre las im??genes
comb = and(bw1,bw2);

%Con el fin de que haya una buena resoluci??n de la transformada, se
%utiliza un hipocicloide de peque??as dimensiones con respecto a la
%transformada, entonces se decide aumentar el tama??o del hipociclode
%mostrado con el fin de que se aprecie de mejor manera. Teniendo en cuenta 
%que se le est?? haciendo la transformada a ese mismo pero de menor tama??o.
p = 1/str2num(sarta{pos})*200;  
R = 1*200;

xx = ((R)-p)*cos(t) + p*cos(t*(((R)-p)/p)) + 256;
yy = ((R)-p)*sin(t) - p*sin(t*(((R)-p)/p)) + 256;

x11=(R)*cos(t) + 256;
y11=(R)*sin(t) + 256;

bw11 = ~poly2mask(xx,yy,512,512);
bw22 = poly2mask(x11,y11,512,512);
comb2 = and(bw11,bw22);

axes(handles.fig1)
imshow(comb2);

%Se realiza la transformada de Fourier del hipocicloide parametrizado al
%inicio
datf = fft2(comb);
axes(handles.fig2)

%Se muestra la transformada y se aplica el abs junto con un comando que
%permite que imshow identifique la escala de grises
imshow(abs(fftshift(datf)),[]); 

%imagen UIS
axes(handles.img)
bkgrnd=imread("uis");
imshow(bkgrnd)
%|||||||||||||||||||||Fin de la explicaci??n del c??digo|||||||||||||||||||||%




% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
