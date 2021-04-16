%{
Creado por: Jose Valles
Titulo: "Seleccion de variables de entrada utilizando AMI"
Fecha: 10/01/2021
%}
%% Importar datos
% Se importa la serie de datos obtenidas del IPSIM Roya
load('IPSIMRoya_inputs.mat')
%% Preprocesamiento
% filtrar por pais
el_salvador = input((input.pais == "el_salvador"),:);
honduras = input((input.pais == "honduras"),:);
dominicana = input((input.pais == "republica_dominicana"),:);
% crear timetable
el_salvador = table2timetable(el_salvador,'RowTimes','fecha_median');
honduras = table2timetable(honduras,'RowTimes','fecha_median');
dominicana = table2timetable(dominicana,'RowTimes','fecha_median');
% detectar meses faltantes
el_salvador = retime(el_salvador,'monthly','fillwithmissing');
honduras = retime(honduras,'monthly','fillwithmissing');
dominicana = retime(dominicana,'monthly','fillwithmissing');
% Crear error t+1
el_salvador.error_t1 = [el_salvador.error_t(2:end);NaN];
honduras.error_t1 = [honduras.error_t(2:end);NaN];
dominicana.error_t1 = [dominicana.error_t(2:end);NaN];
%% Analisis de variables de entrada
% autocorrelacion error
[MI(:,1),~] = ami([dominicana.error_t dominicana.error_t1],20,5);
% Aparicion_hojas vs error 
close all
[MI(:,2),~] = ami([dominicana.Aparicion_hojas dominicana.error_t1],20,5);
% Infeccion vs error 
close all
[MI(:,3),~] = ami([dominicana.Infeccion dominicana.error_t1],20,5);
% Latencia vs error 
close all
[MI(:,4),~] = ami([dominicana.Latencia dominicana.error_t1],20,5);
% Lavado vs error 
close all
[MI(:,5),~] = ami([dominicana.Lavado dominicana.error_t1],20,5);
% numdia_floracion vs error 
close all
[MI(:,6),~] = ami([dominicana.numdia_floracion dominicana.error_t1],20,5);
% incidencia_observada vs error 
close all
[MI(:,7),~] = ami([dominicana.incidencia_observada dominicana.error_t1],20,5);
% incidencia_pronosticada vs error 
close all
[MI(:,8),~] = ami([dominicana.incidencia_pronosticada dominicana.error_t1],20,5);
% numdia_ini_cosecha vs error 
close all
[MI(:,9),~] = ami([dominicana.numdia_ini_cosecha dominicana.error_t1],20,5);
% quimicos vs error 
close all
[MI(:,10),~] = ami([dominicana.quimicos dominicana.error_t1],20,5);
% poda vs error 
close all
[MI(:,11),~] = ami([dominicana.poda dominicana.error_t1],20,5);
% Crear tabla
MI = array2table(MI,'VariableNames',{'autocorrelacion','Aparicionhojas','Infeccion','Latencia','Lavado','numdiafloracion',...
    'incidenciaobservada','incidenciapronosticada','numdiainicosecha','quimicos','poda'});
x = 0:5;
%% Graficar AMI en una misma canvas
close all
plot(x,MI.autocorrelacion,'DisplayName','Autocorrelacion','Color',[1 0 0],'LineWidth',2)
hold on
plot(x,MI.Aparicionhojas,'DisplayName','Aparicion Hoja','Color',[0 1 0],'LineWidth',2)
plot(x,MI.Infeccion,'DisplayName','Infeccion','Color',[0 0 1],'LineWidth',2)
plot(x,MI.Latencia,'DisplayName','Latencia','Color',[1 0 1],'LineWidth',2)
plot(x,MI.Lavado,'DisplayName','Lavado','Color',[0 0 0],'LineWidth',2)
plot(x,MI.numdiafloracion,'DisplayName','Num dia Floracion','Color',[0.8500 0.3250 0.0980],'LineWidth',2)
plot(x,MI.incidenciaobservada,'DisplayName','Incidencia Observada','Color',[0.9290 0.6940 0.1250],'LineWidth',2)
plot(x,MI.incidenciapronosticada,'DisplayName','Incidencia Pronosticada','Color',[0.4940 0.1840 0.5560],'LineWidth',2)
plot(x,MI.numdiainicosecha,'DisplayName','Num dia Inicio Cosecha','Color',[0.4660 0.6740 0.1880],'LineWidth',2)
plot(x,MI.quimicos,'DisplayName','Quimicos','Color',[0.3010 0.7450 0.9330],'LineWidth',2)
plot(x,MI.poda,'DisplayName','Poda','Color',[0.6350 0.0780 0.1840],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
grid on 
box on
legend
%% Graficar AMI en diferentes canvas
ax1 = subplot(5,2,1);
plot(x,MI.autocorrelacion,'DisplayName','Autocorrelacion','Color',[1 0 0],'LineWidth',2)
xlabel('Lag [meses]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax2 = subplot(5,2,2);
plot(x,MI.Aparicionhojas,'DisplayName','Aparicion Hoja','Color',[0 1 0],'LineWidth',2)
xlabel('Lag [m]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax3 = subplot(5,2,3);
plot(x,MI.Infeccion,'DisplayName','Infeccion','Color',[0 0 1],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax4 = subplot(5,2,4);
plot(x,MI.Latencia,'DisplayName','Latencia','Color',[1 0 1],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax5 = subplot(5,2,5);
plot(x,MI.Lavado,'DisplayName','Lavado','Color',[0 0 0],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax6 = subplot(5,2,6);
plot(x,MI.numdiafloracion,'DisplayName','Num dia Floracion','Color',[0.8500 0.3250 0.0980],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax7 = subplot(5,2,7);
plot(x,MI.incidenciaobservada,'DisplayName','Incidencia Observada','Color',[0.9290 0.6940 0.1250],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax8 = subplot(5,2,8);
plot(x,MI.incidenciapronosticada,'DisplayName','Incidencia Pronosticada','Color',[0.4940 0.1840 0.5560],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax9 = subplot(5,2,9);
plot(x,MI.numdiainicosecha,'DisplayName','Num dia Inicio Cosecha','Color',[0.4660 0.6740 0.1880],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

ax10 = subplot(5,2,10);
plot(x,MI.quimicos,'DisplayName','Quimicos','Color',[0.3010 0.7450 0.9330],'LineWidth',2)
xlabel('Lag [months]')
ylabel('AMI')
xlim([0 5])
ylim([0 3])
xticks([0 1 2 3 4 5])
yticks([0 0.5 1.0 1.5 2.0 2.5 3.0])
yticklabels({'0','0.5','1.0','1.5','2.0','2.5','3.0'})
grid on 
box on
legend

