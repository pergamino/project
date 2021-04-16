%{
Creado por: Jose Valles
Titulo: "Entrenamiento de una Red Neuronal Artificial (MLP-ANN)"
Fecha: 10/01/2021
%}
%% Importacion
% Importar los experimentos de ML (A,B,C,D). Estos archivos .mat deben contener la
% series de entrenamiento (t), validacion cruzada (c) y verificacion (v)
inputfile = 'D:\OneDrive\Machine Learning Experoya\03 trabajo\incidencia_matlab\experimentos\A.mat';
load(inputfile)
[~,name,~] = fileparts(inputfile);
%% Parametros del Modelo
% Definir el numero de neuronas 
HiddenNodes = 6; 
% Se definen nombres de variables
nodes = ['n' num2str(HiddenNodes)];
filename = ['Results' name '-' num2str(HiddenNodes) '.mat'];
Etrain = 'Et';
Ecross = 'Ec';
Everif = 'Ev';
Wbias = 'w';
ytraining = 'yt';
ycross = 'yc';
yval = 'yv';
mlp_net = 'networks';
%% Corrida de Feed Forward Multilayer Perceptron Artificial Neural Networks
%{
En este proceso se inicia el proceso de entrenamiento de la ANN en base a
la funcion MLPfunct creada especificamente para una architectura definida.
Se entrena la ANN muchas veces debido a que la inicializacion inicial es un
valor aleatoreo y que afecta la salida del modelo, es por esta razon que se
debe correr muchas veces y encontrar la mejor solucion.
%}
disp('Iniciar el entrenamiento de la Red Neuronal Artificial');
for i = 1:10000
    yti = ['yt' num2str(i)];
    yci = ['yc' num2str(i)];
    yvi = ['yv' num2str(i)];
    netoutput = ['network' num2str(i)];
    [Et,Ec,Ev,w,yt,yc,yv,net] = MLPfunct(HiddenNodes,t,c,v);
    Results.(nodes).(Etrain)(:,i) = Et;
    Results.(nodes).(Ecross)(:,i) = Ec;
    Results.(nodes).(Everif)(:,i) = Ev;
    Results.(nodes).(ytraining).(yti) = yt;
    Results.(nodes).(ycross).(yci) = yc;
    Results.(nodes).(yval).(yvi) = yv;
    Results.(nodes).(Wbias)(:,i) = w;
    Results.(nodes).(mlp_net).(netoutput) = net;
    disp(['ANN Model Run #', num2str(i)])
end
%% Calculo de errores
%{
Busca el menor error (RMSE) de la serie de validacion cruzada
%}
emin = min(Results.(nodes).Ec(3,:));
indx = find(Results.(nodes).Ec(3,:) == emin);
disp(['Error en la serie de validacion cruzada es ', num2str(emin)])
disp(['El indice que corresponde al minimo error en la serie de validacion cruzada es: ', num2str(indx)])

% Buscar la corrida que genera el minimo de error en la validacion cruzada
yvtext = ['yv' num2str(indx)];
yctext = ['yc' num2str(indx)];
yttext = ['yt' num2str(indx)];

%% Extraer series de prediccion en entrenamiento, validacion cruzada y verificacion
yve = (Results.(nodes).yv.(yvtext))';
ycv = (Results.(nodes).yc.(yctext))';
yt = (Results.(nodes).yt.(yttext))';
%% Verificacion para identificar minimos de error
%{
Se identica el valor minimo de cada salida del modelo para cada uno de los datasets. 
%}
minYve = min(yve);
minYcv = min(ycv);
minYt = min(yt);
disp(['The minimum value for the training dataset is ', num2str(minYt)])
disp(['The minimum value for the cross validation dataset is ', num2str(minYcv)])
disp(['The minimum value for the verification dataset is ', num2str(minYve)])
%% Graficas resultados
%{
t: entrenamiento
cv: validacion cruzada
v: verificacion
%}
plotregression(t(:,end),yt,'Entrenamiento')
xlabel('Target')
ylabel('Predicted')

%% Guardar resultados
clearvars -except Results filename yve ycv yt t c v indx
save(filename)