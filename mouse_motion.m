function mouse_motion(x_value, y_value, screen_width, screen_height)
% x_value, y_value son los valores filtrados de cada iteración

% Umbrales para controlar el ratón (en °)
x_threshold = 2;  % Umbral para el eje X
y_threshold = 2;  % Umbral para el eje Y

% Controla el ratón si supera el umbral
if abs(x_value) > x_threshold || abs(y_value) > y_threshold
    % Se escalan las señales X e Y para mover el ratón
    % La señal Y se invierte
    mouse_x = (x_value / 120 + 0.5) * screen_width;  % Mapeo de (-60..60) a (0..width)
    mouse_y = (-y_value / 90 + 0.5) * screen_height; % Mapeo de (-45..45) a (0..height)
    
    % Se asegura que las coordenadas estén dentro de la pantalla
    mouse_x = min(max(mouse_x, 0), screen_width);
    mouse_y = min(max(mouse_y, 0), screen_height);

    set(0, 'PointerLocation', [mouse_x, mouse_y]);
end

    
    

    

    