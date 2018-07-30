function LeakSubtractor( exp_ref )

folderName = 'DofetilideSubtracted';

if ~isdir( folderName )
    mkdir( folderName )
end

if ~isdir( [ folderName '/' exp_ref ] )
    mkdir( [ folderName '/' exp_ref ] )
end


% Calculate parameters from Kylie's files
sw_data = importdata( [ 'FullExperimentalData/dat/' exp_ref '/sine_wave_' exp_ref '.dat' ] );
sw_dofet_data = importdata( [ 'FullExperimentalData/dat/' exp_ref '/sine_wave_dofetilide_' exp_ref '.dat' ] );
I_sw = sw_data( :, 2 );
I_sw_dofet = sw_dofet_data( :, 2 );

% % load kylie's leak subtracted files: 
% load( [ 'FullExperimentalData/dat/' exp_ref '/leak_subtracted/sine_wave_' exp_ref '_leak_subtracted.mat' ] );
% I_sw_ls = T;
% load( [ 'FullExperimentalData/dat/' exp_ref '/leak_subtracted/sine_wave_dofetilide_' exp_ref '_leak_subtracted.mat' ] );
% I_sw_dofet_ls = T;

% Voltage from protocol
% clear T
load( 'Protocols/sine_wave_protocol.mat' )
V_sw = T;

% V_sw = sw_data( :, 3 )-4.1;
% 
% % pick an index at -80
% idx_m80 = 1000;
% % pick an index at -120
% idx_m120 = 2600;
% 
% % Calculate the resistances
% 
% params_sw = [ V_sw(idx_m80) -1 ; V_sw(idx_m120) -1 ] \ [ I_sw( idx_m80 ) - I_sw_ls( idx_m80 );  I_sw( idx_m120 ) - I_sw_ls( idx_m120 )  ];
% params_sw_dofet = [ V_sw(idx_m80) -1 ; V_sw(idx_m120) -1 ] \ [ I_sw_dofet( idx_m80 ) - I_sw_dofet_ls( idx_m80 );  I_sw_dofet( idx_m120 ) - I_sw_dofet_ls( idx_m120 )  ];
% 
% R_sw = 1/params_sw(1);
% C_sw = params_sw(2);

% R_sw_dofet = 1/params_sw_dofet(1);
% C_sw_dofet = params_sw_dofet(2);

% load Kylie's resistances for these cells:

switch exp_ref
    case '16707014'
        R_sw=3000; %16707014 control
        R_sw_dofet=1250; %16707014 dofetilide
    case '16708016'
        R_sw=420; %16708016 control
        R_sw_dofet= 480; %16708016 dofetilide
    case '16708060'
        R_sw=420;  %16708060 control
        R_sw_dofet = 350; %16708060 dofetilide
    case '16708118'
        R_sw=1400; %16708118 control
        R_sw_dofet=1000;  %16708118 dofetilide
    case '16713003'
        R_sw=7500; %16713003 control and dofetilide
        R_sw_dofet=7500; %16713003 control and dofetilide
    case '16713110'
        R_sw=5600; % 16713110 control 
        R_sw_dofet = 7000; % 16713110 dofetilide
    case '16715049'
        R_sw=6000; % 16715049 control
        R_sw_dofet=6500; % 16715049 dofetilide
    case '16704007'
        R_sw=385; % 16704007 control
        R_sw_dofet=260; % 16704007 dofetilide
    case '16704047'
        R_sw=1225; % 16704047 control
        R_sw_dofet=700; % 16704047 d+ofetilide
    case '16705070'
        R_sw=1600; % 16705070 control
        R_sw_dofet=950; %16705070 dofetilide
    otherwise
        disp('Wrong experiment! Default to case 5')
        R_sw=5600; % 16713110 control 
        R_sw_dofet = 7000; % 16713110 dofetilide
end

disp( [ exp_ref ' Delta R (%): ' num2str( 100*(R_sw_dofet-R_sw)/max( abs(R_sw), max(R_sw_dofet ) ) ) ] )
disp( [ exp_ref ' R: ' num2str( R_sw ) ] )
disp( [ exp_ref ' R (dofet): ' num2str( R_sw_dofet ) ] )

% calculate the new leak subtracted and dofetilide subtracted trace

I_sw_ls_n = I_sw - V_sw/(0.001*R_sw);
adjust = mean(I_sw_ls_n(1:1000));
I_sw_ls_n = I_sw_ls_n - adjust;

I_sw_dofet_ls_n = I_sw_dofet - V_sw/(0.001*R_sw_dofet);
adjust = mean(I_sw_dofet_ls_n(1:1000));
I_sw_dofet_ls_n = I_sw_dofet_ls_n - adjust;

T = 1e-3*(I_sw_ls_n - I_sw_dofet_ls_n);
save( [ folderName '/' exp_ref '/sine_wave_' exp_ref '_dofetilide_subtracted_leak_subtracted.mat' ], 'T' );

% Now apply correction and subtraction to all:

protocols = { 'activation_kinetics_1', ...
              'activation_kinetics_2', ...
              'ap',...
              'deactivation',...
              'diveroli_eq_prop',...
              'equal_proportions', ...
              'inactivation',...
              'made_up_2_shifted',...
              'made_up_3_shifted',...
              'max_diff',...
              'maz_wang_div_diff',...
              'original_sine',...
              'steady_activation',...
              'wang_eq_prop' };

num_pr = length( protocols );
          
for pr = 1 : num_pr
    
    protocol = protocols{ pr };
    
    if exist( [ 'FullExperimentalData/dat/' exp_ref '/' protocol '_' exp_ref '.dat' ], 'file' )
        
        data = importdata( [ 'FullExperimentalData/dat/' exp_ref '/' protocol '_' exp_ref '.dat' ] );
        data_dofet = importdata( [ 'FullExperimentalData/dat/' exp_ref '/' protocol '_dofetilide_' exp_ref '.dat' ] );
        I_data = data( :, 2 : 2 : end );
        I_data = I_data( : ); % Reshape into vector
        I_data_dofet = data_dofet( :, 2 : 2 : end );
        I_data_dofet = I_data_dofet( : );

        if ( (strcmp(protocol, 'activation_kinetics_1')||strcmp(protocol,'activation_kinetics_2')) && ...
                (strcmp(exp_ref, '16704007') || strcmp(exp_ref, '16704047')) ) % protocol is different
            V_data = data( :, 3 : 2 : end );
            V_data = V_data( : ) - 4.1; % Remove liquid junction potential
        else
            load( [ 'Protocols/' protocol '_protocol.mat' ] );
            % may be V or T depending on file
            if exist( 'T', 'var' ) == 1
                V_data = T;
                clear T
            else
                V_data = V;
            end
        end
             
        I_data_ls_n = I_data - V_data/(0.001*R_sw);
        adjust = mean(I_data_ls_n(1:1000));
        I_data_ls_n = I_data_ls_n - adjust;
        
        I_data_dofet_ls_n = I_data_dofet - V_data/(0.001*R_sw_dofet);
        adjust = mean(I_data_dofet_ls_n(1:1000));
        I_data_dofet_ls_n = I_data_dofet_ls_n - adjust;
        
        T = 1e-3*(I_data_ls_n - I_data_dofet_ls_n);
        save( [ folderName '/' exp_ref '/' protocol '_' exp_ref '_dofetilide_subtracted_leak_subtracted.mat' ], 'T' );
        clear T
    end
    
end

end
