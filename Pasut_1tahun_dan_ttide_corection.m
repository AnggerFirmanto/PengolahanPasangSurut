% % Memuat data pasang surut dari file CSV
% filename = 'PANJ01_2023.csv';
% data = readtable(filename, 'Delimiter', ';');
% 
% % Memisahkan kolom tanggal dan ketinggian pasang surut
% tanggal = datetime(data{:, 1}, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
% pasangSurut = data{:, 2};
% 
% % Identifikasi nilai yang hilang
% missingIndices = isnan(pasangSurut);
% missingDates = tanggal(missingIndices);
% 
% % Tampilkan nilai yang hilang tiap jamnya
% fprintf('Nilai pasang surut yang kosong tiap jamnya:\n');
% for i = 1:length(missingDates)
%     fprintf('  %s\n', datestr(missingDates(i), 'yyyy-mm-dd HH:MM:SS'));
% end
% 
% % Memeriksa kelengkapan data harian pada data asli
% days = unique(dateshift(tanggal, 'start', 'day')); % Daftar semua hari unik dari data asli
% incompleteDays = []; % Array untuk menyimpan hari yang tidak lengkap
% 
% for i = 1:length(days)
%     currentDay = days(i);
%     dayData = tanggal(dateshift(tanggal, 'start', 'day') == currentDay);
%     
%     if length(dayData) < 24
%         incompleteDays = [incompleteDays; currentDay]; %#ok<AGROW>
%     end
% end
% 
% % Tampilkan hari dengan data tidak lengkap dalam data asli
% if ~isempty(incompleteDays)
%     fprintf('Hari dengan data tidak lengkap dalam data asli:\n');
%     for i = 1:length(incompleteDays)
%         fprintf('  %s\n', datestr(incompleteDays(i), 'yyyy-mm-dd'));
%     end
% else
%     fprintf('Semua data harian dalam data asli lengkap.\n');
% end
% 
% % Membuat array tanggal lengkap untuk satu tahun
% tanggalLengkap = (datetime(2023, 1, 1, 0, 0, 0):hours(1):datetime(2023, 12, 31, 23, 0, 0))';
% 
% % Menggabungkan data asli dengan array tanggal lengkap
% [~, ia, ib] = intersect(tanggalLengkap, tanggal);
% pasangSurutLengkap = nan(size(tanggalLengkap));
% pasangSurutLengkap(ia) = pasangSurut(ib);
% 
% % Identifikasi nilai yang hilang sebelum fillmissing
% missingIndicesBeforeFill = isnan(pasangSurutLengkap);
% 
% % Mengisi nilai yang hilang
% pasangSurutLengkapFilled = fillmissing(pasangSurutLengkap, 'linear');
% 
% % Memeriksa kelengkapan data harian per jam
% days = unique(dateshift(tanggalLengkap, 'start', 'day')); % Daftar semua hari unik
% incompleteDays = []; % Array untuk menyimpan hari yang tidak lengkap
% 
% for i = 1:length(days)
%     currentDay = days(i);
%     dayData = tanggalLengkap(dateshift(tanggalLengkap, 'start', 'day') == currentDay);
%     
%     if length(dayData) < 24
%         incompleteDays = [incompleteDays; currentDay]; %#ok<AGROW>
%     end
% end
% 
% % Tampilkan hari dengan data tidak lengkap
% if ~isempty(incompleteDays)
%     fprintf('Hari dengan data tidak lengkap:\n');
%     for i = 1:length(incompleteDays)
%         fprintf('  %s\n', datestr(incompleteDays(i), 'yyyy-mm-dd'));
%     end
% else
%     fprintf('Semua data harian lengkap.\n');
% end
% 
% % Hitung High Highest Water Level (HHWL) dan Low Lowest Water Level (LLWL)
% HHWL = max(pasangSurutLengkapFilled);
% LLWL = min(pasangSurutLengkapFilled);
% 
% % Hitung Mean High Water Level (MHWL) dan Mean Low Water Level (MLWL)
% highWaterLevels = pasangSurutLengkapFilled(pasangSurutLengkapFilled > mean(pasangSurutLengkapFilled));
% lowWaterLevels = pasangSurutLengkapFilled(pasangSurutLengkapFilled < mean(pasangSurutLengkapFilled));
% MHWL = mean(highWaterLevels);
% MLWL = mean(lowWaterLevels);
% 
% % Hitung Mean Sea Level (MSL)
% MSL = mean(pasangSurutLengkapFilled);
% 
% % Hitung nilai Zo
% Zo = std(pasangSurutLengkapFilled);
% 
% % Tampilkan hasil perhitungan tahunan
% fprintf('Hasil Perhitungan Tahunan:\n');
% fprintf('  High Highest Water Level (HHWL): %.2f cm\n', HHWL);
% fprintf('  Low Lowest Water Level (LLWL): %.2f cm\n', LLWL);
% fprintf('  Mean Sea Level (MSL): %.2f cm\n', MSL);
% fprintf('  Zo: %.2f cm\n', Zo);
% fprintf('  Mean High Water Level (MHWL): %.2f cm\n', MHWL);
% fprintf('  Mean Low Water Level (MLWL): %.2f cm\n\n', MLWL);
% 
% % Analisis T-tide untuk seluruh data selama 1 tahun
% [nameu, fu, tidecon, xout] = t_tide(pasangSurutLengkapFilled, 'start time', datenum(tanggalLengkap(1)), 'interval', 1, 'latitude', -5.4486);
% 
% % Hitung nilai F tahunan
% K1 = NaN; O1 = NaN; M2 = NaN; S2 = NaN; N2 = NaN; K2 = NaN; P1 = NaN; M4 = NaN; MS4 = NaN;
% 
% % Periksa dan dapatkan nilai komponen harmonik jika tersedia
% for j = 1:size(nameu, 1)
%     switch strtrim(nameu(j, :))
%         case 'K1'
%             K1 = tidecon(j, 1);
%         case 'O1'
%             O1 = tidecon(j, 1);
%         case 'M2'
%             M2 = tidecon(j, 1);
%         case 'S2'
%             S2 = tidecon(j, 1);
%         case 'N2'
%             N2 = tidecon(j, 1);
%         case 'K2'
%             K2 = tidecon(j, 1);
%         case 'P1'
%             P1 = tidecon(j, 1);
%         case 'M4'
%             M4 = tidecon(j, 1);
%         case 'MS4'
%             MS4 = tidecon(j, 1);
%     end
% end
% 
% % Hitung nilai F tahunan
% F_tahunan = (K1 + O1) / (M2 + S2);
% 
% % Pastikan nilai F adalah skalar sebelum melakukan perbandingan
% if isscalar(F_tahunan)
%     if F_tahunan < 0.25
%         tipePasangSurutTahunan = 'Semi Diurnal Tide';
%     elseif F_tahunan > 3.0
%         tipePasangSurutTahunan = 'Diurnal Tide';
%     elseif F_tahunan >= 0.26 && F_tahunan < 1.5
%         tipePasangSurutTahunan = 'Mixed Tide Prevailing Semidiurnal';
%     elseif F_tahunan >= 1.5 && F_tahunan <= 3.0
%         tipePasangSurutTahunan = 'Mixed Tide Prevailing Diurnal';
%     else
%         tipePasangSurutTahunan = 'Unknown';
%     end
% else
%     tipePasangSurutTahunan = 'Unknown';
% end
% 
% fprintf('Tipe Pasang Surut Tahunan: %s (F = %.2f)\n', tipePasangSurutTahunan, F_tahunan);
% 
% % Simpan data hasil koreksi T-tide dalam format CSV
% % outputFilename = 'hasil_koreksi_t_tide.csv';
% % T = table(tanggalLengkap, xout, 'VariableNames', {'Tanggal', 'TinggiPasangSurut'});
% % writetable(T, outputFilename);
% % fprintf('Data hasil koreksi T-tide telah disimpan dalam file %s\n', outputFilename);
% 
% % Plotting data pasang surut lengkap dan data hasil koreksi T-tide
% figure;
% subplot(3,1,1);
% plot(tanggalLengkap, pasangSurutLengkap, 'b');
% datetick('x', 'yyyy-mm-dd');
% title('Data Pasang Surut Sebelum Fillmissing');
% xlabel('Tanggal');
% ylabel('Tinggi Pasang Surut (cm)');
% grid on;
% 
% subplot(3,1,2);
% plot(tanggalLengkap, pasangSurutLengkapFilled, 'g');
% datetick('x', 'yyyy-mm-dd');
% title('Data Pasang Surut Sesudah Fillmissing');
% xlabel('Tanggal');
% ylabel('Tinggi Pasang Surut (cm)');
% grid on;
% 
% subplot(3,1,3);
% plot(tanggalLengkap, xout, 'r');
% datetick('x', 'yyyy-mm-dd');
% title('Data Pasang Surut Setelah Koreksi T-tide');
% xlabel('Tanggal');
% ylabel('Tinggi Pasang Surut (cm)');
% grid on;
% 
% % Analisis bulanan
% bulanUnik = unique(month(tanggalLengkap));
% 
% for i = 1:length(bulanUnik)
%     indeksBulan = month(tanggalLengkap) == bulanUnik(i);
%     tanggalBulan = tanggalLengkap(indeksBulan);
%     pasangSurutBulan = pasangSurutLengkapFilled(indeksBulan);
% 
%     % Hitung HHWL, LLWL, MSL, dan Zo untuk setiap bulan
%     HHWL_bulan = max(pasangSurutBulan);
%     LLWL_bulan = min(pasangSurutBulan);
%     MSL_bulan = mean(pasangSurutBulan);
%     Zo_bulan = std(pasangSurutBulan);
%     
%     % Hitung MHWL dan MLWL untuk setiap bulan
%     highWaterLevels_bulan = pasangSurutBulan(pasangSurutBulan > MSL_bulan);
%     lowWaterLevels_bulan = pasangSurutBulan(pasangSurutBulan < MSL_bulan);
%     MHWL_bulan = mean(highWaterLevels_bulan);
%     MLWL_bulan = mean(lowWaterLevels_bulan);
% 
%     fprintf('Bulan %d Tahun %d:\n', bulanUnik(i), year(tanggalLengkap(1)));
%     fprintf('  High Highest Water Level (HHWL): %.2f cm\n', HHWL_bulan);
%     fprintf('  Low Lowest Water Level (LLWL): %.2f cm\n', LLWL_bulan);
%     fprintf('  Mean Sea Level (MSL): %.2f cm\n', MSL_bulan);
%     fprintf('  Zo: %.2f cm\n', Zo_bulan);
%     fprintf('  Mean High Water Level (MHWL): %.2f cm\n', MHWL_bulan);
%     fprintf('  Mean Low Water Level (MLWL): %.2f cm\n\n', MLWL_bulan);
% 
%     % Analisis T-tide untuk data bulanan
%     [nameu_bulan, fu_bulan, tidecon_bulan, xout_bulan] = t_tide(pasangSurutBulan, 'start time', datenum(tanggalBulan(1)), 'interval', 1, 'latitude', -5.4486);
%     
%     % Hitung nilai F bulanan
%     K1_bulan = NaN; O1_bulan = NaN; M2_bulan = NaN; S2_bulan = NaN; N2_bulan = NaN; K2_bulan = NaN; P1_bulan = NaN; M4_bulan = NaN; MS4_bulan = NaN;
%     
%     for j = 1:size(nameu_bulan, 1)
%         switch strtrim(nameu_bulan(j, :))
%             case 'K1'
%                 K1_bulan = tidecon_bulan(j, 1);
%             case 'O1'
%                 O1_bulan = tidecon_bulan(j, 1);
%             case 'M2'
%                 M2_bulan = tidecon_bulan(j, 1);
%             case 'S2'
%                 S2_bulan = tidecon_bulan(j, 1);
%             case 'N2'
%                 N2_bulan = tidecon_bulan(j, 1);
%             case 'K2'
%                 K2_bulan = tidecon_bulan(j, 1);
%             case 'P1'
%                 P1_bulan = tidecon_bulan(j, 1);
%             case 'M4'
%                 M4_bulan = tidecon_bulan(j, 1);
%             case 'MS4'
%                 MS4_bulan = tidecon_bulan(j, 1);
%         end
%     end
% 
%     F_bulanan = (K1_bulan + O1_bulan) / (M2_bulan + S2_bulan);
% 
%     if isscalar(F_bulanan)
%         if F_bulanan < 0.25
%             tipePasangSurutBulanan = 'Semi Diurnal Tide';
%         elseif F_bulanan > 3.0
%             tipePasangSurutBulanan = 'Diurnal Tide';
%         elseif F_bulanan >= 0.26 && F_bulanan < 1.5
%             tipePasangSurutBulanan = 'Mixed Tide Prevailing Semidiurnal';
%         elseif F_bulanan >= 1.5 && F_bulanan <= 3.0
%             tipePasangSurutBulanan = 'Mixed Tide Prevailing Diurnal';
%         else
%             tipePasangSurutBulanan = 'Unknown';
%         end
%     else
%         tipePasangSurutBulanan = 'Unknown';
%     end
%     
%     fprintf('  Tipe Pasang Surut Bulanan: %s (F = %.2f)\n', tipePasangSurutBulanan, F_bulanan);
%     fprintf('-------------------------------------------\n');
% 
%     % Simpan data hasil koreksi T-tide bulanan dalam format CSV
% %     outputFilenameBulan = sprintf('hasil_koreksi_t_tide_bulan_%d.csv', bulanUnik(i));
% %     TBulan = table(tanggalBulan, xout_bulan, 'VariableNames', {'Tanggal', 'TinggiPasangSurut'});
% %     writetable(TBulan, outputFilenameBulan);
% %     fprintf('Data hasil koreksi T-tide untuk bulan %d telah disimpan dalam file %s\n', bulanUnik(i), outputFilenameBulan);
% 
%     % Plotting data pasang surut bulanan dan data hasil koreksi T-tide
%     figure;
%     subplot(2,1,1);
%     plot(tanggalBulan, pasangSurutBulan, 'b');
%     datetick('x', 'dd');
%     title(sprintf('Data Pasang Surut Bulanan (%d-%d)', bulanUnik(i), year(tanggalLengkap(1))));
%     xlabel('Tanggal');
%     ylabel('Tinggi Pasang Surut (cm)');
%     grid on;
% 
%     subplot(2,1,2);
%     plot(tanggalBulan, xout_bulan, 'r');
%     datetick('x', 'dd');
%     title(sprintf('Data Pasang Surut setelah Koreksi T-tide (%d-%d)', bulanUnik(i), year(tanggalLengkap(1))));
%     xlabel('Tanggal');
%     ylabel('Tinggi Pasang Surut (cm)');
%     grid on;
% end


% Memuat data pasang surut dari file CSV
filename = 'PANJ01_2014.csv';
data = readtable(filename, 'Delimiter', ';');

% Memisahkan kolom tanggal dan ketinggian pasang surut
tanggal = datetime(data{:, 1}, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
pasangSurut = data{:, 2};

% Identifikasi nilai yang hilang
missingIndices = isnan(pasangSurut);
missingDates = tanggal(missingIndices);

% Tampilkan nilai yang hilang tiap jamnya
fprintf('Nilai pasang surut yang kosong tiap jamnya:\n');
for i = 1:length(missingDates)
    fprintf('  %s\n', datestr(missingDates(i), 'yyyy-mm-dd HH:MM:SS'));
end

% Memeriksa kelengkapan data harian pada data asli
days = unique(dateshift(tanggal, 'start', 'day')); % Daftar semua hari unik dari data asli
incompleteDays = []; % Array untuk menyimpan hari yang tidak lengkap

for i = 1:length(days)
    currentDay = days(i);
    dayData = tanggal(dateshift(tanggal, 'start', 'day') == currentDay);
    
    if length(dayData) < 24
        incompleteDays = [incompleteDays; currentDay]; %#ok<AGROW>
    end
end

% Tampilkan hari dengan data tidak lengkap dalam data asli
if ~isempty(incompleteDays)
    fprintf('Hari dengan data tidak lengkap dalam data asli:\n');
    for i = 1:length(incompleteDays)
        fprintf('  %s\n', datestr(incompleteDays(i), 'yyyy-mm-dd'));
    end
else
    fprintf('Semua data harian dalam data asli lengkap.\n');
end

% Membuat array tanggal lengkap untuk satu tahun
tanggalLengkap = (datetime(2014, 1, 1, 0, 0, 0):hours(1):datetime(2014, 12, 31, 23, 0, 0))';

% Menggabungkan data asli dengan array tanggal lengkap
[~, ia, ib] = intersect(tanggalLengkap, tanggal);
pasangSurutLengkap = nan(size(tanggalLengkap));
pasangSurutLengkap(ia) = pasangSurut(ib);

% Identifikasi nilai yang hilang sebelum fillmissing
missingIndicesBeforeFill = isnan(pasangSurutLengkap);

% Mengisi nilai yang hilang
pasangSurutLengkapFilled = fillmissing(pasangSurutLengkap, 'linear');

% Memeriksa kelengkapan data harian per jam
days = unique(dateshift(tanggalLengkap, 'start', 'day')); % Daftar semua hari unik
incompleteDays = []; % Array untuk menyimpan hari yang tidak lengkap

for i = 1:length(days)
    currentDay = days(i);
    dayData = tanggalLengkap(dateshift(tanggalLengkap, 'start', 'day') == currentDay);
    
    if length(dayData) < 24
        incompleteDays = [incompleteDays; currentDay]; %#ok<AGROW>
    end
end

% Tampilkan hari dengan data tidak lengkap
if ~isempty(incompleteDays)
    fprintf('Hari dengan data tidak lengkap:\n');
    for i = 1:length(incompleteDays)
        fprintf('  %s\n', datestr(incompleteDays(i), 'yyyy-mm-dd'));
    end
else
    fprintf('Semua data harian lengkap.\n');
end

% Hitung High Highest Water Level (HHWL) dan Low Lowest Water Level (LLWL)
HHWL = max(pasangSurutLengkapFilled);
LLWL = min(pasangSurutLengkapFilled);

% Hitung Mean High Water Level (MHWL) dan Mean Low Water Level (MLWL)
highWaterLevels = pasangSurutLengkapFilled(pasangSurutLengkapFilled > mean(pasangSurutLengkapFilled));
lowWaterLevels = pasangSurutLengkapFilled(pasangSurutLengkapFilled < mean(pasangSurutLengkapFilled));
MHWL = mean(highWaterLevels);
MLWL = mean(lowWaterLevels);

% Hitung Mean Sea Level (MSL)
MSL = mean(pasangSurutLengkapFilled);

% Hitung nilai Zo
Zo = mean(pasangSurutLengkapFilled);

% Tampilkan hasil perhitungan tahunan
fprintf('Hasil Perhitungan Tahunan:\n');
fprintf('  High Highest Water Level (HHWL): %.2f cm\n', HHWL);
fprintf('  Low Lowest Water Level (LLWL): %.2f cm\n', LLWL);
fprintf('  Mean Sea Level (MSL): %.2f cm\n', MSL);
fprintf('  Zo: %.2f cm\n', Zo);
fprintf('  Mean High Water Level (MHWL): %.2f cm\n', MHWL);
fprintf('  Mean Low Water Level (MLWL): %.2f cm\n\n', MLWL);

% Analisis T-tide untuk seluruh data selama 1 tahun
[nameu, fu, tidecon, xout] = t_tide(pasangSurutLengkapFilled, 'start time', datenum(tanggalLengkap(1)), 'interval', 1, 'latitude', -5.4486);

% % Menyimpan hasil T-tide correction ke dalam file CSV
% outputFilename = 'Tide_Corrected_Data_2023.csv';
% outputTable = table(tanggalLengkap, xout, 'VariableNames', {'Datetime', 'Corrected_Tide'});
% writetable(outputTable, outputFilename);

% Plot data tahunan
figure;
subplot(3, 1, 1);
plot(tanggalLengkap, pasangSurutLengkap, 'b');
title('Data Pasang Surut Asli (Tahunan)');
xlabel('Tanggal');
ylabel('Ketinggian (cm)');

subplot(3, 1, 2);
plot(tanggalLengkap, pasangSurutLengkapFilled, 'r');
title('Data Pasang Surut Setelah Fillmissing (Tahunan)');
xlabel('Tanggal');
ylabel('Ketinggian (cm)');

subplot(3, 1, 3);
plot(tanggalLengkap, xout, 'g');
title('Data Pasang Surut Setelah T-Tide Correction (Tahunan)');
xlabel('Tanggal');
ylabel('Ketinggian (cm)');

% Hitung nilai F tahunan
K1 = NaN; O1 = NaN; M2 = NaN; S2 = NaN; N2 = NaN; K2 = NaN; P1 = NaN; M4 = NaN; MS4 = NaN;

% Periksa dan dapatkan nilai komponen harmonik jika tersedia
for j = 1:size(nameu, 1)
    switch strtrim(nameu(j, :))
        case 'K1'
            K1 = tidecon(j, 1);
        case 'O1'
            O1 = tidecon(j, 1);
        case 'M2'
            M2 = tidecon(j, 1);
        case 'S2'
            S2 = tidecon(j, 1);
        case 'N2'
            N2 = tidecon(j, 1);
        case 'K2'
            K2 = tidecon(j, 1);
        case 'P1'
            P1 = tidecon(j, 1);
        case 'M4'
            M4 = tidecon(j, 1);
        case 'MS4'
            MS4 = tidecon(j, 1);
    end
end

% Tampilkan nilai konstanta harmonik
fprintf('Nilai Konstanta Harmonik:\n');
fprintf('  M2: %.2f\n', M2);
fprintf('  S2: %.2f\n', S2);
fprintf('  K2: %.2f\n', K2);
fprintf('  N2: %.2f\n', N2);
fprintf('  K1: %.2f\n', K1);
fprintf('  O1: %.2f\n', O1);
fprintf('  P1: %.2f\n', P1);
fprintf('  M4: %.2f\n', M4);
fprintf('  MS4: %.2f\n\n', MS4);

% Hitung nilai HHWL, MHWL, MSL, MLWL, dan LLWL sesuai rumus yang diberikan
Z0 = MSL;
HHWL = Z0 + (M2 + S2 + K2 + K1 + O1 + P1);
MHWL = Z0 + (M2 + K1 + O1);
MLWL = Z0 - (M2 + K1 + O1);
LLWL = Z0 - (M2 + S2 + K2 + K1 + O1 + P1);

% Tampilkan hasil perhitungan
fprintf('Hasil Perhitungan dengan Rumus yang Diberikan:\n');
fprintf('  Higher High Water Level (HHWL): %.2f cm\n', HHWL);
fprintf('  Mean High Water Level (MHWL): %.2f cm\n', MHWL);
fprintf('  Mean Sea Level (MSL): %.2f cm\n', Z0);
fprintf('  Mean Low Water Level (MLWL): %.2f cm\n', MLWL);
fprintf('  Lower Low Water Level (LLWL): %.2f cm\n', LLWL);

% Hitung nilai F tahunan
F_tahunan = (K1 + O1) / (M2 + S2);

% Tampilkan nilai F tahunan
fprintf('Nilai F Tahunan: %.2f\n', F_tahunan);

% Pastikan nilai F adalah skalar sebelum melakukan perbandingan
if isscalar(F_tahunan)
    if F_tahunan < 0.25
        tipePasangSurutTahunan = 'Semi Diurnal Tide';
    elseif F_tahunan > 3.0
        tipePasangSurutTahunan = 'Diurnal Tide';
    elseif F_tahunan >= 0.26 && F_tahunan < 1.5
        tipePasangSurutTahunan = 'Mixed Tide Prevailing Semidiurnal';
    elseif F_tahunan >= 1.5 && F_tahunan <= 3.0
        tipePasangSurutTahunan = 'Mixed Tide Prevailing Diurnal';
    end
else
    tipePasangSurutTahunan = 'Nilai F_tahunan tidak valid';
end

% Tampilkan tipe pasang surut tahunan
fprintf('Tipe Pasang Surut Tahunan: %s\n', tipePasangSurutTahunan);

% Menghitung nilai F bulanan
fprintf('Hasil Perhitungan Bulanan:\n');
months = unique(dateshift(tanggalLengkap, 'start', 'month'));
for i = 1:length(months)
    currentMonth = months(i);
    monthlyData = pasangSurutLengkapFilled(dateshift(tanggalLengkap, 'start', 'month') == currentMonth);
    [nameu_monthly, fu_monthly, tidecon_monthly, xout_monthly] = t_tide(monthlyData, 'start time', datenum(currentMonth), 'interval', 1, 'latitude', -5.4486);
    
    % Inisialisasi nilai komponen harmonik bulanan
    K1_monthly = NaN; O1_monthly = NaN; M2_monthly = NaN; S2_monthly = NaN; N2_monthly = NaN; K2_monthly = NaN; P1_monthly = NaN; M4_monthly = NaN; MS4_monthly = NaN;

    for j = 1:size(nameu_monthly, 1)
        switch strtrim(nameu_monthly(j, :))
            case 'K1'
                K1_monthly = tidecon_monthly(j, 1);
            case 'O1'
                O1_monthly = tidecon_monthly(j, 1);
            case 'M2'
                M2_monthly = tidecon_monthly(j, 1);
            case 'S2'
                S2_monthly = tidecon_monthly(j, 1);
            case 'N2'
                N2_monthly = tidecon_monthly(j, 1);
            case 'K2'
                K2_monthly = tidecon_monthly(j, 1);
            case 'P1'
                P1_monthly = tidecon_monthly(j, 1);
            case 'M4'
                M4_monthly = tidecon_monthly(j, 1);
            case 'MS4'
                MS4_monthly = tidecon_monthly(j, 1);
        end
    end

    % Menghitung nilai F bulanan
    F_bulanan = (K1_monthly + O1_monthly) / (M2_monthly + S2_monthly);
    
    % Hitung nilai Zo bulanan
    Z0_bulanan = mean(monthlyData);

    % Tampilkan nilai komponen harmonik bulanan dan Z0
    fprintf('Bulan %s:\n', datestr(currentMonth, 'mmmm yyyy'));
    fprintf('  M2: %.2f\n', M2_monthly);
    fprintf('  S2: %.2f\n', S2_monthly);
    fprintf('  K2: %.2f\n', K2_monthly);
    fprintf('  N2: %.2f\n', N2_monthly);
    fprintf('  K1: %.2f\n', K1_monthly);
    fprintf('  O1: %.2f\n', O1_monthly);
    fprintf('  P1: %.2f\n', P1_monthly);
    fprintf('  M4: %.2f\n', M4_monthly);
    fprintf('  MS4: %.2f\n', MS4_monthly);
    fprintf('  Zo: %.2f cm\n', Z0_bulanan);
    fprintf('  Nilai F Bulanan: %.2f\n', F_bulanan); % Menampilkan nilai F bulanan

    % Pastikan nilai F adalah skalar sebelum melakukan perbandingan
    if isscalar(F_bulanan)
        if F_bulanan < 0.25
            tipePasangSurutBulanan = 'Semi Diurnal Tide';
        elseif F_bulanan > 3.0
            tipePasangSurutBulanan = 'Diurnal Tide';
        elseif F_bulanan >= 0.26 && F_bulanan < 1.5
            tipePasangSurutBulanan = 'Mixed Tide Prevailing Semidiurnal';
        elseif F_bulanan >= 1.5 && F_bulanan <= 3.0
            tipePasangSurutBulanan = 'Mixed Tide Prevailing Diurnal';
        end
    else
        tipePasangSurutBulanan = 'Nilai F_bulanan tidak valid';
    end

    % Tampilkan tipe pasang surut bulanan
    fprintf('  Tipe Pasang Surut Bulanan: %s\n\n', tipePasangSurutBulanan);
    
    % Plot data bulanan
    figure;
    subplot(3, 1, 1);
    plot(tanggalLengkap(dateshift(tanggalLengkap, 'start', 'month') == currentMonth), pasangSurutLengkap(dateshift(tanggalLengkap, 'start', 'month') == currentMonth), 'b');
    title(['Data Pasang Surut Asli (', datestr(currentMonth, 'mmmm yyyy'), ')']);
    xlabel('Tanggal');
    ylabel('Ketinggian (cm)');

    subplot(3, 1, 2);
    plot(tanggalLengkap(dateshift(tanggalLengkap, 'start', 'month') == currentMonth), monthlyData, 'r');
    title(['Data Pasang Surut Setelah Fillmissing (', datestr(currentMonth, 'mmmm yyyy'), ')']);
    xlabel('Tanggal');
    ylabel('Ketinggian (cm)');

    subplot(3, 1, 3);
    plot(tanggalLengkap(dateshift(tanggalLengkap, 'start', 'month') == currentMonth), xout_monthly, 'g');
    title(['Data Pasang Surut Setelah T-Tide Correction (', datestr(currentMonth, 'mmmm yyyy'), ')']);
    xlabel('Tanggal');
    ylabel('Ketinggian (cm)');
    
%     % Simpan data yang dikoreksi ke dalam file CSV untuk setiap bulan
%     monthlyOutputFilename = sprintf('Tide_Corrected_Data_%s.csv', datestr(currentMonth, 'mmm_yyyy'));
%     monthlyOutputTable = table(tanggalLengkap(dateshift(tanggalLengkap, 'start', 'month') == currentMonth), xout_monthly, 'VariableNames', {'Datetime', 'Corrected_Tide'});
%     writetable(monthlyOutputTable, monthlyOutputFilename);
end
