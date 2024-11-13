%% Cargar la API de BioRadio
current_dir = cd;
[deviceManager, flag] = load_API([current_dir '\BioRadioSDK.dll']);
if ~flag
    return;
end

%% Seleccionar dispositivo
[deviceName, macID, ok] = BioRadio_Find(deviceManager);
if ~ok
    errordlg('Please select a BioRadio.');
    return;
end

%% Inicializar conexión
[myDevice, flag] = BioRadio_Connect(deviceManager, macID, deviceName);
% por dentro hace esto:
% myDevice = deviceManager.GetBluetoothDevice(macID)
if ~flag
    return;
end

%% Configuración
ConfigActual = myDevice.GetConfiguration() % Se mostrará en consola

ConfigActual.samplingRate = 1000; % Frecuencia de muestreo (Hz)
ConfigActual.sensorConfiguration.accelerometerEnabled = true;
ConfigActual.sensorConfiguration.gyroscopeEnabled = true;
ConfigActual.channelConfiguration(1).termination = BioPotentialTermination.SingleEnded;
%ConfigActual.channelConfiguration(2).termination = BioPotentialTermination.SingleEnded;
% BioPotentialTermination.Differential;

myDevice.SetConfiguration(ConfigActual);