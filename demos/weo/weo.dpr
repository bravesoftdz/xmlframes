program weo;


uses
  Forms,
  U_FormMainIni,
  U_XMLFenetrePrincipale,
  U_Splash,
  Windows,
  U_MultiDonnees,
  U_CustomFrameWork,
  ADODB,
  fonctions_ObjetsXML,
  fonctions_string,
  fonctions_xml,
  fonctions_system,
  Dialogs;

{$R WindowsXP.res}


var
	gc_classname: Array[0..255] of char;
	gi_result: integer;

begin
	Application.Initialize;
	Application.Title := 'Test';

	// Met dans gc_classname le nom de la class de l'application
	GetClassName(Application.handle, gc_classname, 254);

  gs_NomApp := fs_GetNameSoft;
  
	// Renvoie le Handle de la premi�re fen�tre de Class (type) gc_classname
	// et de titre TitreApplication (0 s'il n'y en a pas)
	gi_result := FindWindow(gc_classname, @gs_NomApp);

	if gi_result <> 0 then   // Une instance existante trouv�e
		begin
			ShowWindow(gi_result, SW_RESTORE);
			SetForegroundWindow(gi_result);
			Application.Terminate;
			Exit;
		end
	else  // Premi�re cr�ation
		begin
			Application.Title := gs_NomApp;
		end;

	F_SplashForm := TF_SplashForm.Create(Application);
	F_SplashForm.Label1.Caption := 'GENERIC' ;
	F_SplashForm.Label1.Width   := F_SplashForm.Width ;
	F_SplashForm.Show;   // Affichage de la fiche
	F_SplashForm.Update; // Force la fiche � se dessiner compl�tement

	try
		gb_DicoKeyFormPresent  := True ;
		gb_DicoUseFormField    := True ;
		gb_DicoGroupementMontreCaption := False ;
		Application.CreateForm(TM_Donnees, M_Donnees);
    if not fb_ReadIni ( gmif_MainFormIniInit ) Then
      ShowMessage ( 'XML file not initalized.' );

    Application.CreateForm(TF_FenetrePrincipale, F_FenetrePrincipale);
       // Il n'y a pas de menu donc rootentities est une fen�tre
  if not assigned ( gNod_DashBoard ) then
     p_CreateRootEntititiesForm;

  finally
	end;

	p_RegisterClasses ([]);

	Application.Run;
end.
