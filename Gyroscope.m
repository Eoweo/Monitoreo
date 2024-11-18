%% Codigo para adquisición de señales en tiempo real
% Versión con controlador de mouse


% Filtro pasabajos
Fs = 20;  % Frecuencia de muestreo en Hz
Fc = 3;    % Frecuencia de corte en Hz)
d = designfilt('lowpassiir', 'FilterOrder', 2, ...
    'HalfPowerFrequency', Fc, 'SampleRate', Fs);

% Dimensiones de la pantalla (en píxeles)
screen_size = get(0, 'ScreenSize'); % [left, bottom, width, height]
screen_width = screen_size(3);
screen_height = screen_size(4);

% Se crean las figuras y subplots
figure;
axs = cell(2, 3); % {1,i}: eje i raw, {2,i}: eje i filtrado
labels = ["Eje X °", "Eje Y °", "Eje Z °"];
for i = 1:3
    subplot(3,1,i);
    axs{1, i} = animatedline;
    axs{2, i} = animatedline('Color','blue');
    ylabel(labels(i));
    grid on;
    if i == 1
        title('Orientacion (X, Y, Z)');
        legend("Raw","Filtered");
    end
    hold on;
end
xlabel("Tiempo [s]");


clear t raw_filt_data;
% {1,i}: datos eje i raw, {2,i}: datos filtrados
raw_filt_data = cell(2,3);
ori_0 = [0, 0, 0];

% Conexión a celular
if ~exist('m', 'var')
	m = mobiledev();
end

m.OrientationSensorEnabled = 1;
m.Logging = 1;
pause(1);

i=1;
last_plot_update = 0;
tic;
while true
    
    % Si se presiona 'alt' + '1' se termina el ciclo
    % Se debe estar en la ventana del gráfico
    key = get(gcf, 'CurrentKey');
    modifiers = get(gcf, 'CurrentModifier');    
    if ismember('alt', modifiers) && strcmp(key, '1')
        disp('Adquisición Terminada.');
        break;
    end

	ori = m.orientation;
    if i == 1
        % Se ajusta a la posición actual del celu
        ori_0 = ori;
        ori_0 = [0, 0, 0];
    end
    t(i) = toc;
    
    for j = 1:3
        raw_filt_data{1, j}(i) = ori(j) - ori_0(j);
        f = filter(d, raw_filt_data{1,j});
        raw_filt_data{2, j}(i) = f(end);

        addpoints(axs{1,j}, t(i), raw_filt_data{1,j}(i));
        addpoints(axs{2,j}, t(i), raw_filt_data{2,j}(i));
    end

    if i > 501 && mod(i, 50) == 0
        time_window = [t(i-500) t(i)+1];
        for j = 1:3
            subplot(3,1,i);
            xlim(time_window);
        end
        last_plot_update = i;
    end

    drawnow;

    mouse_motion(raw_filt_data{2,1}(i), raw_filt_data{2,2}(i), screen_width, screen_height);
    
    i = i+1;
	pause(1/Fs);
end

m.Logging = 0;
m.OrientationSensorEnabled = 0;