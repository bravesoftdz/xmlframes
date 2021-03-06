unit u_xmlform;


{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

///////////////////////////////////////////////////////////////////////
// Nom Unite: U_FXMLForm
// Description : Création d'une fiche automatisée
// Créé par Matthieu GIROUX le 15/03/2009
///////////////////////////////////////////////////////////////////////

uses
 {$IFDEF FPC}
 LCLType, ExtJvXPButtons,
 {$ELSE}
 Windows, JvXPButtons,
 {$ENDIF}
  Controls, Classes, DB,
  U_ExtDBNavigator, Forms,
  ComCtrls, SysUtils,
  U_CustomFrameWork, U_OnFormInfoIni,
  fonctions_string, ALXmlDoc, fonctions_xml, ExtCtrls,
  u_xmlfillcombobutton,
  fonctions_dbservice,
  fonctions_manbase,
{$IFDEF RX}
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  u_framework_components,
  u_multidata,  Menus, fonctions_ObjetsXML,
  u_man_reports_components, DBGrids,
  Graphics, U_GroupView;

{$IFDEF VERSIONS}
const

    gVer_TXMLForm : T_Version = ( Component : 'Composant TF_XMLForm' ;
                                  FileUnit  : 'U_XMLForm' ;
                                  Owner     : 'Matthieu Giroux' ;
                                  Comment   : 'Fiche personnalisée avec création de composant à partir du XML.' ;
                                  BugsStory : '0.9.2.0 : centralizimg on manframes.'  + #13#10 +
                                              '0.9.1.6 : Adapting to ManFrames and auto create sql.'  + #13#10 +
                                              '0.9.1.5 : centralizing on ManFrames.'  + #13#10 +
                                              '0.9.1.4 : UTF 8.'  + #13#10 +
                                              '0.9.1.3 : Testing.'  + #13#10 +
                                              '0.9.1.2 : Forcing Not registered forms when searching form xml file.'  + #13#10 +
                                              '0.9.1.1 : Integrating TXMLFillCombo button.'  + #13#10 +
                                              '0.9.1.0 : Really integrating group view.'  + #13#10 +
                                              '0.9.0.2 : Childs Source for struct node.'  + #13#10 +
                                              '0.9.0.1 : Creating struct fields and components.'  + #13#10 +
                                              '0.9.0.0 : Reading a LEONARDI file and creating HMI.'  + #13#10 +
                                              '0.0.2.0 : Identification, more functionalities.'  + #13#10 +
                                              '0.0.1.0 : Working on weo.'   ;
                                  UnitType  : 3 ;
                                  Major : 0 ; Minor : 9 ; Release : 2; Build : 0 );
{$ENDIF}

type
  { TF_XMLForm }
  { Form created from XML}

  TF_XMLForm = class(TF_CustomFrameWork)
  private
  { Déclarations privées }
     // XML Creating
    gwin_Last : TWinControl;
    gwin_Parent : TWinControl;
    gi_LastFormFieldsHeight, gi_LastFormColumnHeight : Longint;

    gfin_FormIni : TOnFormInfoIni ;
    FPageControl : TCustomTabControl ;
    FPanelMain   ,
    FActionPanel : TPanel;
    gr_Function : TLeonFunction ;
    gfwe_Password, gfwe_Login : TFWEdit;
    gbtn_PrintButton : TFWPrintSources;
    function fpc_CreatePageControl(const awin_Parent: TWinControl;
      const as_Name: String; const apan_PanelOrigin: TWinControl): TPageControl;
    procedure p_CloseLoginAction(AObject: TObject;
      var ACLoseAction: TCloseaction);
    procedure p_LoginCancelClick(AObject: TObject);
    procedure p_LoginOKClick(AObject: TObject);
    procedure p_setFunction ( const a_Value : TLeonFunction );
  protected
    gxml_SourceFile : TALXMLDocument ;
    procedure p_ScruteComposantsFiche (); override;
    procedure p_setChoiceComponent( const argr_Control : TCustomRadioGroup );
    function  fwin_CreateFieldComponentAndProperties( const anod_Field: TALXMLNode;
                                                            awin_parent, awin_last : TWinControl;
                                                      var   ai_FieldCounter : Longint ;
                                                      var  ab_Column : Boolean ; const afws_Source : TFWSource ;
                                                      const ab_SeparateIfTooMuch : Boolean = True ):TWinControl; virtual;
    function flab_setFieldComponentProperties( const anod_Field: TALXMLNode; const awin_Control, awin_Parent : TWinControl;
      const ai_Counter: Integer ; const ab_Column : Boolean; const afcf_ColumnField : TFWFieldColumn ): TFWLabel; virtual;
    procedure p_SetFieldButtonsProperties(const anod_Action : TALXMLNode;
      const ai_Counter: Integer); virtual;
    procedure p_setControlName ( const as_FunctionName : String ; const anod_FieldProperty : TALXMLNode ;  const awin_Control : TControl; const ai_Counter : Longint ); virtual;
    function  fb_ChargementNomCol ( const AFWColumn : TFWSource ; const ai_NumSource : Integer ) : Boolean; override;
    procedure p_AfterColumnFrameShow( const aFWColumn : TFWSource ); override;
    procedure DoClose ( var CloseAction : TCloseAction ); override;
    function fb_ChargeDonnees : Boolean; override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    function fpan_GridNavigationComponents(const awin_Parent: TWinControl; const as_Name : String ;
      const ai_Counter: Integer): TScrollBox; virtual;
  public
    function fb_InsereCompteur ( const adat_Dataset : TDataset ;
                                 const aff_Cle : TFWFieldColumns ;
                                 const as_ChampCompteur, as_Table, as_PremierLettrage : String ;
                                 const ach_DebutLettrage, ach_FinLettrage : Char ;
                                 const ali_Debut, ali_LimiteRecherche : Int64 ): Boolean; override;

    procedure DoShow; override;
    { Déclarations publiques }
    procedure p_setLogin ( const axml_Login : TALXMLDocument;
                           const axb_ident : TJvXPButton ;
                           const amen_MenuIdent : TMenuItem ;
                           const aiml_Images : TImageList ;
                           const abmp_DefaultImage : TBitmap ;
                           var ai_CountImages : Longint );
    procedure BeforeCreateFrameWork(Sender: TComponent);  override;
    procedure DestroyComponents ( const acom_Parent : TWinControl ); virtual;
    procedure p_CreateFormComponents ( const as_XMLClass, as_Name : String ;  awin_Parent : TWinControl ) ; virtual;
    constructor Create ( AOwner : TComponent ); override;
    property Fonction : TLeonFunction read gr_Function write p_setfunction;
  published
    property ActionPanel : TPanel read FActionPanel write FActionPanel;
    property PanelMain   : TPanel read FPanelMain write FPanelMain;
    property PageControl : TCustomTabControl read FPageControl write FPageControl;
  end;


implementation

uses u_languagevars, fonctions_proprietes, U_ExtNumEdits,
     fonctions_autocomponents,
     fonctions_dialogs,
     Math,
     fonctions_Objets_Dynamiques,
     fonctions_languages,
     u_buttons_defs,
     fonctions_xmlform,
     u_buttons_appli,
     unite_variables, StdCtrls;

var  gb_LoginFormLoaded : Boolean = False;



// functions and procédures not methods

procedure p_OnColumnNameNode ( const ADBSources : TFWTables; const anod_ANode : TALXMLNode );
Begin
  with ADBSources, ADBSources.Owner as TF_XMLForm do
   DBSources [ Count - 1 ].Title := fs_GetLabelCaption ( anod_ANode.Attributes [ CST_LEON_VALUE ] );
End;
// child procedure p_CreateParentAndFieldsComponent
// Creates the navigation grid and fields components
// anod_ANode : current node
procedure p_OnCreateParentAndFieldsComponent ( const ADBSources : TFWTables;const ADBSource : TFWTable;
                                               const anod_ANode : TALXMLNode ;
                                               var ab_FieldFound, ab_column : Boolean ;
                                               var   ai_Fieldcounter : Longint );
Begin
  if    anod_ANode.HasAttribute(CST_LEON_FIELD_TYPE) // compositions are not yet supported
  and ( anod_ANode.Attributes[CST_LEON_FIELD_TYPE] = CST_LEON_FIELD_COMPOSITION ) Then
    Exit;
  with ADBSources.Owner as TF_XMLForm,Fonction do
   Begin
    if not ab_FieldFound Then
      Begin
        if ( ADBSources.Count = 1 ) Then
            Begin
              gwin_Parent := fpan_GridNavigationComponents ( gwin_Parent, Name, ADBSource.Index );
              Hint := fs_GetLabelCaption ( Name );
              ShowHint := True;
            End
         else
          Begin
            gwin_Parent := fscb_CreateTabSheet ( FPageControl, ADBSources.Owner as TWinControl, FPanelMain, Name, Name, ADBSources.Owner as TComponent );
            gwin_Parent := fpan_GridNavigationComponents ( gwin_Parent, Name , ADBSource.Index);
          End;
        ab_FieldFound := True;
      end;
    gwin_Last := fwin_CreateFieldComponentAndProperties ( anod_ANode, gwin_Parent, gwin_Last, ai_Fieldcounter,
                                                          ab_Column, ADBSource as TFWSource );
    inc ( ai_Fieldcounter );
   end;

end;

// procedure p_CreateFieldsButtonsComponents
// Creates the Fields and buttons
// anod_ANode : current node
procedure p_OnFieldsButtonsComponents (  const ADBSources : TFWTables;const ADBSource : TFWTable;
                                         const anod_ANode : TALXMLNode ;
                                         var ab_FieldFound, ab_column : Boolean ;
                                         var   ai_Fieldcounter : Longint );

var li_k : Longint;
Begin
  if  ( anod_ANode.NodeName = CST_LEON_ACTIONS ) then
    with ADBSources.Owner as TF_XMLForm do
      Begin
        for li_k := 0 to anod_ANode.ChildNodes.Count -1 do
          p_SetFieldButtonsProperties ( anod_ANode.ChildNodes [ li_k ], ADBSource.Index );
      End;
End;

{ TF_XMLForm }

////////////////////////////////////////////////////////////////////////////////
//  Recherche du nom de l'executable pour aller
//  chercher la bonne fonction d'initialisation
////////////////////////////////////////////////////////////////////////////////
Constructor TF_XMLForm.Create(AOwner: TComponent);
Begin

  if not ( csDesigning in ComponentState ) Then
    Try
      GlobalNameSpace.BeginWrite;
      Include(FFormState, fsCreating);

      {$IFDEF FPC}
      CreateNew(AOwner, 1 );
      {$ELSE}
      CreateNew(AOwner);
      {$ENDIF}
      Exclude(FFormState, fsCreating);
    Finally
      GlobalNameSpace.EndWrite;
      gstl_SQLWork := nil ;
      p_InitFrameWork ( AOwner );
      // Creating objects
      p_CreateColumns;

      {$IFDEF SFORM}
      InitSuperForm;
      {$ENDIF}
    End
  Else
   Begin
     inherited ;
     Exit ;
   end;
  DBCloseMessage := True;
  gfwe_Password := nil;
  gfwe_Login    := nil;
end;


// procedure DestroyComponents
// Destroy all the visible components for the form to be re-used
// Initiate the XML Form
// Parameter : acom_Parent : If not nil destroy only the controls child of acom_Parent
procedure TF_XMLForm.DestroyComponents( const acom_Parent : TWinControl );
var li_i : Integer ;
begin
  for li_i := ComponentCount -1 downto 0 do
    if ( not assigned ( acom_Parent )
        or (( Components [ li_i ] is TWinControl ) and ( acom_Parent = ( Components [ li_i ] as TWinControl ).Parent ))) Then
      Begin
        Components [ li_i ].Free ;
      End ;
  gxml_SourceFile := nil ;
  p_InitFrameWork ( Self );
end;

// Function fb_ChargementNomCol
// Inherited function, just make it true
function TF_XMLForm.fb_ChargementNomCol(const AFWColumn: TFWSource;
  const ai_NumSource: Integer): Boolean;
begin
  Result := True;
end;


// function fpan_GridNavigationComponents
// Create a complete Grid navigation with Navigators returning the child created ScrollBox for the editing form
// awin_Parent : The grid navigation and editing parent
// const as_Name : name for caption
// const ai_Counter : Column counter
function TF_XMLForm.fpan_GridNavigationComponents ( const awin_Parent : TWinControl ; const as_Name : String ; const ai_Counter : Integer ): TScrollBox;
var lpan_ParentPanel : TPanel ;
    lpan_Panel : TPanel ;
    ldbn_Navigator : TExtDBNavigator ;
    ldbg_Grid      : TCustomDBGrid;
    lfwc_Column    : TFWSource ;
    lcon_Control   : TControl ;
begin
  lfwc_Column := DBSources [ ai_Counter ] as TFWSource;
  lpan_ParentPanel := fpan_CreatePanel ( awin_Parent, CST_COMPONENTS_PANEL_MAIN + as_Name + IntToStr(ai_counter), Self, alClient );
  lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  lpan_ParentPanel.ShowHint := True;
  lpan_Panel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, alLeft );
  lpan_Panel.Width := CST_GRID_NAVIGATION_WIDTH;
  lpan_Panel.Constraints.MinWidth := CST_GRID_NAVIGATION_MIN_WIDTH;
  ldbn_Navigator := fdbn_CreateNavigation ( lpan_Panel, CST_COMPONENTS_NAVIGATOR_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, False, alTop );
  lfwc_Column.Navigator := ldbn_Navigator;
  ldbg_Grid      := fdbg_CreateGrid ( lpan_Panel, CST_COMPONENTS_DBGRID_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, False, alClient );
  lfwc_Column.Grid := ldbg_Grid;
  lcon_Control := fspl_CreateSplitter ( lpan_ParentPanel, CST_COMPONENTS_SPLITTER_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, alLeft );
  lcon_Control.Left := lpan_Panel.Width;
  if ai_Counter = 0 then
    FPanelMain := lpan_ParentPanel;
  lpan_ParentPanel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + as_Name, Self, alClient );
  lfwc_Column.PanelDetails := lpan_ParentPanel;
  lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  lpan_ParentPanel.ShowHint := True;
  lpan_Panel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_EDIT + as_Name, Self, alTop );
  ldbn_Navigator := fdbn_CreateNavigation ( lpan_Panel, CST_COMPONENTS_NAVIGATOR_BEGIN + CST_COMPONENTS_EDIT + as_Name, Self, True, alTop );
  lfwc_Column.NavEdit := ldbn_Navigator;
  Result := fscb_CreateScrollBox ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_CONTROLS + as_Name, Self, alClient );
  lfwc_Column.Panels.Add.Panel := Result ;
End;


// function fwin_CreateFieldComponent
// Creates some field components from  anod_Field
// awin_Parent : Parent of created components
// anod_Field : Node which wants a component


// overrided procedure p_AfterColumnFrameShow
// aFWColumn : abstract Column showing
procedure TF_XMLForm.p_AfterColumnFrameShow( const aFWColumn : TFWSource );
begin
end;

// overrided procedure DoClose
// Free the XML Form
// Setting CloseAction to cafree
procedure TF_XMLForm.DoClose(var CloseAction: TCloseAction);
begin
  inherited DoClose(CloseAction);
  CloseAction := caFree;
end;

function TF_XMLForm.fb_ChargeDonnees: Boolean;
begin
  Result:= True;
end;

function TF_XMLForm.fb_InsereCompteur(const adat_Dataset: TDataset;
  const aff_Cle: TFWFieldColumns; const as_ChampCompteur, as_Table,
  as_PremierLettrage: String; const ach_DebutLettrage, ach_FinLettrage: Char;
  const ali_Debut, ali_LimiteRecherche: Int64): Boolean;
begin
  Result:=False;
end;


// procedure p_setLogin
// Special Login model
// axml_Login : XML Document of login form
procedure TF_XMLForm.p_setLogin(const axml_Login: TALXMLDocument;
  const axb_ident: TJvXPButton; const amen_MenuIdent: TMenuItem;
  const aiml_Images: TImageList; const abmp_DefaultImage: TBitmap;
  var ai_CountImages: Longint);
var
    li_i, li_j, li_Counter : Longint;
    lnod_Node, lnod_NodeChild : TALXMLNode ;
    gxmd_xmlSource : TALXMLDocument;
    ls_class   : String;
    lwin_Control  : TWinControl;
    lfwl_Label    : TFWLabel;
    lfwc_Column   : TFWSource ;
begin
  DisableAlign ;
  Screen.Cursor := Self.Cursor;
  for li_i := 0 to axml_Login.ChildNodes.Count - 1 do
    Begin
      lnod_Node := axml_Login.ChildNodes [ li_i ];
      if lnod_Node.NodeName = CST_LEON_ACTION Then
        Begin
          lfwc_Column := nil;
          Width  := 350;
          Height := 250 ;
          // Creating DBSources
          if lnod_Node.HasChildNodes Then
          for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
            Begin
              lnod_NodeChild := lnod_Node.ChildNodes [ li_j ];
              if  ( lnod_NodeChild.NodeName = CST_LEON_ACTION_PREFIX )
              and not gb_LoginFormLoaded then
               Begin
                 p_setPrefixToMenuAndXPButton ( lnod_NodeChild.Attributes [ CST_LEON_VALUE ], axb_ident, amen_MenuIdent, aiml_Images );
                 gb_LoginFormLoaded := True;
               end;
              if lnod_NodeChild.NodeName = CST_LEON_NAME Then
                Caption := fs_GetLabelCaption(lnod_NodeChild.Attributes [ CST_LEON_VALUE ]);
              if  ( lnod_NodeChild.NodeName = CST_LEON_PARAMETER )
              and lnod_NodeChild.HasAttribute ( CST_LEON_PARAMETER_NAME )
              and ( lnod_NodeChild.Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_USER_CLASS )
               Then
                 Begin
                   if lnod_NodeChild.HasAttribute ( CST_LEON_IDREF )
                    Then ls_class := lnod_NodeChild.Attributes [ CST_LEON_IDREF ]
                    else Application.Terminate;

                   gxmd_xmlSource := nil;
                   p_CreateComponents ( DBSources, ls_class, ls_class, Self, nil, gxmd_xmlSource, nil, nil, nil );
                   lfwc_Column := DBSources[0];
                   {$IFDEF DBNET}
                     If ( lfwc_Column.Connection.DatasetType = dtDBNet ) Then
                      Begin
//                       p_SetComponentBoolProperty(lfwc_Column.Connection.QueryCopy, 'GetFields', True );
                       p_FindAndSetSourceKey(lnod_NodeChild.Attributes [ CST_LEON_IDREF ],lfwc_Column, Self, FieldDelimiter);
                      end;
                   {$ENDIF}
                 end;
            end;
          li_Counter := 0 ;
          // Setting login parameters
          for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
            Begin
              lnod_NodeChild := lnod_Node.ChildNodes [ li_j ];
              with lnod_NodeChild do
              if  ( NodeName = CST_LEON_PARAMETER )
              and HasAttribute ( CST_LEON_PARAMETER_NAME )
              and (  ( Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_LOGIN_INFO    )
                  or ( Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_PASSWORD_INFO ))
               Then
                Begin
                   Begin
                     lwin_Control := fwin_CreateAEditComponent ( Self, False, True );
                     with lwin_Control do
                      Begin
                       Parent := Self;
                       Left := CST_XML_FIELDS_CAPTION_SPACE;
                       Name := CST_COMPONENTS_EDIT_BEGIN+Attributes [ CST_LEON_PARAMETER_NAME ]+IntToStr(li_j);
                       Text := '';
                       Width := 120;
                      end;
                     lfwl_Label   := ffwl_CreateALabelComponent ( Self, Self, lwin_Control, lfwc_Column.FieldsDefs.Add, Attributes [ CST_LEON_PARAMETER_NAME ], li_Counter, False );
                     if ( Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_LOGIN_INFO ) Then
                       Begin
                         li_counter := 0;
                         lwin_Control.Top := 50 ;
                         lfwl_Label  .Top := 50 ;
                         lfwl_Label  .Caption := GS_LOGIN;
                         gfwe_Login := lwin_Control as TFWEdit;
                       end
                      Else
                       Begin
                         li_counter := 1;
                         lwin_Control.Top := 100 ;
                         lfwl_Label  .Top := 100 ;
                         lfwl_Label  .Caption := GS_PASSWORD;
                         gfwe_Password := lwin_Control as TFWEdit;
                         gfwe_Password.PasswordChar:='*';
                       End;
                     p_setLabelComponent ( lwin_Control, lfwl_Label, False );
                     with lfwc_Column.FieldsDefs [ lfwc_Column.FieldsDefs.Count - 1 ] do
                       Begin
                         FieldName:= Attributes [ CST_LEON_IDREF ];
                         NumTag:= li_counter + 1 ;
                       end;
                   end;
                end;
            end;
          // Setting buttons
          lwin_Control := TFWOK.Create(Self);
          with lwin_Control as TFWOK do
           Begin
            Parent := Self;
            Name   := CST_COMPONENTS_BUTTON_BEGIN+ClassName+IntToStr(li_i);
            Width  := 90;
            Height := 25;
            Left:= Self.Width div 2 - ( Width * 2 ) div 2;
            Top := 150 ;
            OnClick := p_LoginOKClick;
           end;
          lwin_Control := TFWCancel.Create(Self);
          with lwin_Control as TFWCancel do
           Begin
            Parent := Self;
            Name   := CST_COMPONENTS_BUTTON_BEGIN+ClassName+IntToStr(li_i);
            Width  := 90;
            Height := 25;
            Left:= Self.Width div 2 + Width div 2;
            Top := 150 ;
            OnClick := p_LoginCancelClick;
           end;
        end;
      end;
  if not gb_LoginFormLoaded Then
    Begin
      gb_LoginFormLoaded := True;
      p_setImageToMenuAndXPButton(abmp_DefaultImage,axb_ident,amen_MenuIdent,aiml_Images);
    end;
  ai_CountImages:=aiml_Images.Count;
  OnClose:=p_CloseLoginAction;
  Name := CST_COMPONENTS_FORM_BEGIN + 'AutoLoginForm' ;
  // Initiate data and showing
  EnableAlign ;
  FormCreate ( Self );
  Position := poMainFormCenter;
//  FormStyle:=fsNoStayOnTop;
//  Application.MainForm.WindowState:=wsMinimized;
  ShowModal;
//  Application.MainForm.WindowState:=wsMaximized;
end;
// procedure p_LoginOKClick
// Login OK Button event
// AObject : Needed for event
procedure TF_XMLForm.p_LoginOKClick( AObject : TObject );
var lb_ok : Boolean;
Begin
  if assigned ( gNod_DashBoard ) Then
  with DBSources [ 0 ] do
   if Datasource.DataSet.Active Then
    Begin
      // no user so can enter
      if Datasource.DataSet.IsEmpty Then
        Begin
          p_CreeAppliFromNode ( '' );
          Close;
          Exit;
        end;
      // Verifying form
      if  not assigned ( gfwe_Password )
      and not Assigned( gfwe_Login ) Then
        Exit;
      lb_ok := False;
      // verifying password
      if FieldsDefs [ 0 ].NumTag = 1 Then
        Begin
          Datasource.DataSet.Locate(FieldsDefs [ 0 ].FieldName,gfwe_Login.Text,[loCaseInsensitive]);
          if Datasource.DataSet.FieldByName(FieldsDefs [ 1 ].FieldName).AsString = gfwe_Password.Text Then
            lb_ok := True;
        end
       Else
        Begin
         Datasource.DataSet.Locate(FieldsDefs [ 1 ].FieldName,gfwe_Login.Text,[loCaseInsensitive]);
         if Datasource.DataSet.FieldByName(FieldsDefs [ 0 ].FieldName).AsString = gfwe_Password.Text Then
           lb_ok := True;
        end;
      if lb_ok Then
        Begin
          gs_user := gfwe_Login.Text;
          p_CreeAppliFromNode ( '' );
          Close;
          Exit;
        end
       Else
        MyShowmessage(GS_LOGIN_FAILED);
    end;
end;

// procedure TF_XMLForm.KeyUp
// Auto OK Login key event
// AObject : Needed for event
procedure TF_XMLForm.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if ( Key = VK_RETURN )
  and assigned ( gfwe_Password ) Then
   p_LoginOKClick (Self );
end;

procedure TF_XMLForm.Doshow;
var li_i : Integer;
    lcom_Component : TComponent;
begin
  // No LFM Bug
  for li_i := 0 to ComponentCount - 1 do
    Begin
     lcom_Component := Components [ li_i ];
     if lcom_Component is TFWButton Then
      Begin
       (lcom_Component as TFWButton).Loaded;
       Continue;
      end;
     if lcom_Component is TDBGroupView Then
      Begin
        (lcom_Component as TDBGroupView).Loaded;
        Continue;
      end;
     if ( lcom_Component is TExtDBNumEdit )
     and (( lcom_Component as TExtDBNumEdit ).Field is TIntegerField )   then
       Begin
        ( lcom_Component as TExtDBNumEdit ).NbAfterComma:=0;
       end;

    end;
  inherited;
end;

function TF_XMLForm.fpc_CreatePageControl(const awin_Parent: TWinControl;
  const as_Name: String; const apan_PanelOrigin: TWinControl): TPageControl;
begin
  gi_MainFieldsHeight := gi_LastFormFieldsHeight;
  Result:=fonctions_autocomponents.fpc_CreatePageControl(awin_Parent,as_Name,apan_PanelOrigin,Self);
end;

// procedure p_CloseLoginAction
// Login close event
procedure TF_XMLForm.p_CloseLoginAction( AObject : TObject; var ACLoseAction : TCloseaction );
Begin
  ACloseAction := caFree;
  gf_users := nil;
end;

// procedure p_LoginCancelClick
// Cancel Click event
procedure TF_XMLForm.p_LoginCancelClick( AObject : TObject );
Begin
  Close;
end;

// procedure p_setControlName
// Setting control name from node
procedure TF_XMLForm.p_setControlName (  const as_FunctionName : String ; const anod_FieldProperty : TALXMLNode ;  const awin_Control : TControl; const ai_Counter : Longint );
Begin
  awin_Control.Name := fs_EraseSpecialChars( awin_Control.ClassName + as_FunctionName + trim ( anod_FieldProperty.Attributes [ CST_LEON_VALUE ] ) + IntToStr ( ai_Counter ));

End;

// procedure p_setFunction
// Creating the components of the form from TLeonFunction into array
// a_Value : Menu function
procedure TF_XMLForm.p_setFunction(const a_Value: TLeonFunction);
var li_i : Integer ;
    li_Action : Longint ;
    lpan_Panel : TPanel;
begin
  with a_Value do
    p_CopyLeonFunction ( a_Value, gr_Function );
 if a_value.AFile = ''
  then Name := a_value.Name
  Else Name := a_value.AFile;
 DisableAlign ;
 try
   Caption := fs_GetLabelCaption ( gr_Function.Name );
   with gr_Function do
     Begin
       // Simple function
      if (high ( Functions ) < 0 ) then
        Begin
          DestroyComponents ( nil );
          p_CreateFormComponents ( gr_Function.AFile,gr_Function.Name, fpan_CreateActionPanel ( Self, Self, FActionPanel ) );
        End
      else
        Begin
          // Compound function
          DestroyComponents ( nil );
          lpan_Panel := fpan_CreateActionPanel ( Self, Self, FActionPanel );
          for li_i := 0 to ( high ( Functions )) do
            Begin
              li_Action := fi_FindAction ( Functions [ li_i ] );
              p_CreateFormComponents ( ga_Functions [ li_Action ].AFile, ga_Functions [ li_Action ].Name, lpan_Panel );
            End;
         End;
     End;
   FormCreate ( Self );

   gfin_FormIni.p_ExecuteLecture(Self);
 finally
   EnableAlign ;
 end;
end;

// procedure p_setChoiceComponent
// After having read child node from choice node setting the height of choice node
// argr_Control : Choice component

procedure TF_XMLForm.p_setChoiceComponent( const argr_Control : TCustomRadioGroup );
var li_i, li_length : Integer;
Begin
  with argr_Control do
    begin
      Height:= Items.Count  * gi_FontHeight + Byte(BorderStyle)  * 2 ;
      li_length := 0;
      for li_i := 0 to Items.Count -1 do
        li_length:=Max(Canvas.GetTextWidth(Items [ li_i ]), li_length );
      Columns := (CST_XML_SEGUND_COLUMN_MIN_POSWIDTH+CST_XML_FIELDS_LABEL_INTERLEAVING*2) div li_length ;
    end;
end;


// Function flab_setFieldComponentProperties
// creating the label component and setting the field component from child nodes
// anod_Field : component node
// awin_Control : created field component
// awin_Parent : Parent component
// afd_FieldDef : Field definitions
// ai_Counter : Field Counter
// afws_Source : XML Form Column
// ab_Column : Segund editing column
// afcf_ColumnField : Field Form column definitions

function TF_XMLForm.flab_setFieldComponentProperties(
  const anod_Field: TALXMLNode; const awin_Control, awin_Parent: TWinControl;
  const ai_Counter: Integer; const ab_Column: Boolean;
  const afcf_ColumnField: TFWFieldColumn): TFWLabel;
var li_i : LongInt ;
    ldo_Temp : Double ;
    lnod_FieldProperties : TALXMLNode ;
Begin
  Result := nil;
  if anod_Field.HasChildNodes then
    for li_i := 0 to anod_Field.ChildNodes.Count -1 do
      Begin
        ldo_Temp := 0 ;
        lnod_FieldProperties := anod_Field.ChildNodes [ li_i ];
        if awin_Control is TCustomRadioGroup then
          Begin
            if fb_setChoiceProperties ( lnod_FieldProperties, awin_Control as TCustomRadioGroup ) Then
              Continue;
          End;

        if lnod_FieldProperties.NodeName = CST_LEON_NAME then
          Begin
            if ( awin_Control is TCustomRadioGroup )
             Then p_setComponentProperty ( awin_Control, 'Caption', fs_GetLabelCaption(lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]))
             Else Result := ffwl_CreateALabelComponent ( Self, awin_Parent, awin_Control, afcf_ColumnField, lnod_FieldProperties.Attributes [ CST_LEON_VALUE ], ai_Counter, ab_Column );
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_NROWS then
          Begin
            p_setComponentProperty ( awin_Control, 'Rows', lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_TIP then
          Begin
            awin_Control.Hint := fs_GetLabelCaption ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
            awin_Control.ShowHint := True;
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_NCOLS then
          Begin
            p_setComponentProperty ( awin_Control, 'Cols', lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_MAX then
          Begin
            if ( awin_Control is TExtNumEdit ) then
              try // numedit is a customedit
                DecimalSeparator := '.' ;
                ldo_Temp := Abs ( StrToFloat ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]));

                if awin_Control.Width < ldo_Temp * CST_XML_FIELDS_CHARLENGTH then
                  awin_Control.Width := length ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ] ) * CST_XML_FIELDS_CHARLENGTH;
                p_setComponentProperty ( awin_Control, 'Max', lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
                p_setComponentBoolProperty ( awin_Control, 'HasMax', True);
              Except
              end
            else if ( awin_Control is TCustomEdit ) then
              try
                ldo_Temp := lnod_FieldProperties.Attributes [ CST_LEON_VALUE ];
                p_setComponentProperty ( awin_Control, 'MaxLength', ldo_Temp);
                awin_Control.Width :=  Min ( 50, CST_XML_FIELDS_CHARLENGTH ) * StrToInt ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
              Except
              end;
            try
              afcf_ColumnField.FieldSize := Trunc ( ldo_Temp );
            Except
            end;
            DecimalSeparator := gchar_DecimalSeparator ;
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_MIN then
          Begin
            if ( awin_Control is TExtNumEdit ) then
              try  // numedit is a customedit
                DecimalSeparator := '.' ;
                ldo_Temp := StrToFloat ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
                if awin_Control.Width < ldo_Temp * CST_XML_FIELDS_CHARLENGTH then
                  awin_Control.Width := Min ( 50, Round ( ldo_Temp * CST_XML_FIELDS_CHARLENGTH ));
                p_setComponentProperty ( awin_Control, 'Min', ldo_Temp);
                p_setComponentBoolProperty ( awin_Control, 'HasMin', True);
              Except
              end
            else if ( awin_Control is TCustomEdit ) then
              try
                ldo_Temp := lnod_FieldProperties.Attributes [ CST_LEON_VALUE ];
                p_setComponentProperty ( awin_Control, 'MinLength', ldo_Temp);
              Except
              end;
            DecimalSeparator := gchar_DecimalSeparator ;
            Continue;
          End;
      End;
  // after setting the choice component setting the height
  if awin_Control is TCustomRadioGroup then
    Begin
      p_setChoiceComponent ( awin_Control as TCustomRadioGroup );
    End;

End;

// procedure p_SetFieldButtonsProperties
// Setting the editing buttons
// anod_Action : Action node for buttons
// ai_Counter : column counter
// awin_Parent : Parent component
procedure TF_XMLForm.p_SetFieldButtonsProperties(const anod_Action: TALXMLNode;
  const ai_Counter: Integer);
var ls_Action   : String ;
begin
  with DBSources [ ai_Counter ] do
    if  ( anod_Action.NodeName = CST_LEON_ACTION_REF )
    and assigned ( NavEdit ) then
      Begin
        ls_Action :=  anod_Action.Attributes [ CST_LEON_ACTION_IDREF ];
        if ls_Action = CST_LEON_ACTION_REF_SET then
          Begin
            NavEdit.VisibleButtons := NavEdit.VisibleButtons + [nbEPost,nbECancel];
            Exit;
          End;

        if ls_Action = CST_LEON_ACTION_REF_DELETE then
          Begin
            NavEdit.VisibleButtons := NavEdit.VisibleButtons + [nbEDelete];
            Exit;
          End;
        if ( ls_Action = CST_LEON_ACTION_REF_ADD   )
        or ( ls_Action = CST_LEON_ACTION_REF_CLONE ) then
          Begin
            NavEdit.VisibleButtons := NavEdit.VisibleButtons + [nbEInsert];
            Exit;
          End;
        if  ( ls_Action = CST_LEON_ACTION_REF_PRINT )
        and ( DBSources.count > 0 )
         then
          Begin
            gbtn_PrintButton := TFWPrintSources.Create ( Self );
            with gbtn_PrintButton do
              Begin
                Width := 90;
                Left := Left - Width;
                Caption := gs_print;
              end;
            fpan_CreateAction ( gbtn_PrintButton, CST_COMPONENTS_BUTTON_PRINT, Self, FActionPanel );
            Exit;
          End;
      End;


end;

procedure TF_XMLForm.p_ScruteComposantsFiche();
begin
end;

// procedure p_CreateFieldComponentAndProperties
// Creating the column components
// as_Table : Table Name
// anod_Field: Node field
// ai_FieldCounter : Field counter
//  ai_Counter : Column counter
// awin_Parent : Parent component
// ab_Column : Second editing column
// afws_Source : XML form Column
// afd_FieldsDefs : Field Definitions
function TF_XMLForm.fwin_CreateFieldComponentAndProperties ( const anod_Field: TALXMLNode;
                                                                   awin_parent, awin_last : TWinControl;
                                                             var   ai_FieldCounter : Longint ;
                                                             var  ab_Column : Boolean ; const afws_Source : TFWSource ;
                                                             const ab_SeparateIfTooMuch : Boolean = True ):TWinControl;
var llab_Label  : TFWLabel;
    lb_IsRelation,
    lb_IsLocal  : Boolean;
    lffd_ColumnFieldDef : TFWFieldColumn;
    lnod_OriginalNode : TALXmlNode;
    lxfc_ButtonCombo : TXMLFillCombo;
    FPage : TCustomTabControl;


    // procedure p_CreateArrayStructComponents
    // Creating groupbox with controls
    procedure p_CreateArrayStructComponents ;
    var li_k, li_l, li_FieldCounter : LongInt ;
        lb_column : Boolean;
        ls_NodeId : String;
        lwin_last : TWinControl;
        lfwt_Source2 : TFWTable;
        lnod_FieldsNode : TALXmlNode;
    begin
      lfwt_Source2:=nil;
      lnod_OriginalNode := fnod_GetNodeFromTemplate(anod_Field);
      if anod_Field <> lnod_OriginalNode Then
        Begin
         if fb_getOptionalStructTable ( DBSources,afws_Source,lfwt_Source2,lffd_ColumnFieldDef,anod_Field,lnod_OriginalNode )
          Then
            Exit;
        end;

      li_FieldCounter := 0 ;
      ls_NodeId := anod_Field.Attributes[CST_LEON_ID];
      Result := fgrb_CreateGroupBox(awin_Parent,CST_COMPONENTS_GROUPBOX_BEGIN + ls_NodeId + IntToStr(ai_FieldCounter),Self,alNone);
      lnod_OriginalNode := fnod_GetNodeFromTemplate(anod_Field);
      if lnod_OriginalNode.HasChildNodes then
        for li_k := 0 to lnod_OriginalNode.ChildNodes.Count - 1 do
          Begin
            lnod_FieldsNode := lnod_OriginalNode.ChildNodes [ li_k ];
            if lnod_FieldsNode.NodeName = CST_LEON_NAME then
              Begin
                p_SetComponentProperty(Result,'Caption',fs_GetLabelCaption(lnod_FieldsNode.Attributes[CST_LEON_VALUE]));
                Continue;
              End;
            if (   lnod_OriginalNode.NodeName = CST_LEON_STRUCT )
            and lnod_OriginalNode.ChildNodes [ li_k ].HasChildNodes then
              Begin
                lb_column := False;
                lwin_last:=nil;
                if lnod_FieldsNode.NodeName = CST_LEON_FIELDS Then
                  Begin
                    for li_l := 0 to lnod_FieldsNode.ChildNodes.Count - 1 do
                      Begin
                        if anod_Field <> lnod_OriginalNode Then
                          lwin_last:=fwin_CreateFieldComponentAndProperties ( lnod_FieldsNode.ChildNodes [ li_l ],
                                                                   Result, lwin_last,
                                                                   li_FieldCounter,
                                                                   lb_column, lfwt_Source2 as TFWSource, False )
                         else
                          lwin_last:=fwin_CreateFieldComponentAndProperties ( lnod_FieldsNode.ChildNodes [ li_l ],
                                                                   Result, lwin_last,
                                                                   ai_FieldCounter,
                                                                   ab_column, afws_Source, False );
                      end;
                  end
                 Else
                  // The parent parameter is a var : so do not want to change it in the function
                  if anod_Field <> lnod_OriginalNode Then
                    lwin_last:=fwin_CreateFieldComponentAndProperties ( lnod_OriginalNode.ChildNodes [ li_k ],
                                                             Result, lwin_last,
                                                             li_FieldCounter,
                                                             lb_column, lfwt_Source2 as TFWSource, False )
                   else
                    lwin_last:=fwin_CreateFieldComponentAndProperties ( lnod_FieldsNode.ChildNodes [ li_k ],
                                                             Result, lwin_last,
                                                             ai_FieldCounter,
                                                             ab_column, afws_Source, False );
              end;
          end;
      // set top of groupbox
      p_setFieldComponentTop ( Result, awin_last, ab_Column );
      //set left and width
      p_setComponentLeftWidth  ( Result, ab_Column );
      with lwin_last do
       Result.ClientHeight := Top +(Height + CST_CONTROLS_INTERLEAVING)*2; // do not forget groupbox caption
    end;

    // procedure p_CreateComponents
    // Creating the component and setting data link

    function fb_CreateComponents ( var awin_Control : TWinControl ) : Boolean ;
     Begin
      Result := False;
      llab_Label:=nil;
      // adding not local field
      lffd_ColumnFieldDef := afws_Source.FieldsDefs.Add ;
      if not fb_createFieldID ( True, anod_Field, lffd_ColumnFieldDef, ai_FieldCounter )
       Then
        Begin
          afws_Source.FieldsDefs.Delete(lffd_ColumnFieldDef.Index);
          Exit;
        end;
      if //( anod_Field.NodeName = CST_LEON_ARRAY ) // to do
       ( anod_Field.NodeName = CST_LEON_STRUCT )
       Then
        Begin
          p_CreateArrayStructComponents;
          p_FieldIsNotAKey( lffd_ColumnFieldDef );
          // Quitting because having created component
          Result := True;
          Exit;
        end;
      lb_IsRelation:=False;
      lb_IsLocal := fb_setFieldType(afws_Source,lffd_ColumnFieldDef,anod_Field,ai_FieldCounter,True,False,Self,lb_IsRelation);

      p_SetFieldSelect ( lffd_ColumnFieldDef, lb_IsLocal );

      with lffd_ColumnFieldDef do
       if ColUnique and AutoIncField
       and ( ColPrivate or ColHidden )
        Then
         Exit;

      if lb_IsRelation
      Then awin_Control := ffwc_getRelationComponent(DBSources,afws_source,awin_parent,lffd_ColumnFieldDef,lxfc_ButtonCombo,anod_Field.Attributes[CST_LEON_ID],lb_IsLocal,Self)
      Else
       Begin
         awin_Control := fwin_CreateAFieldComponent ( lffd_ColumnFieldDef, Self, lb_IsLocal );
         if  ( awin_Control = nil ) then
           Begin
             MyShowmessage ( Gs_NoComponentToCreate + lffd_ColumnFieldDef.FieldName +'.' );
             gb_Unload := True;
           End;
       End;

      if not assigned ( awin_Control )
      or ( awin_Control is TDBGroupView ) then
        Exit;

      // create eventually a tabsheet if too many controls
      If ab_SeparateIfTooMuch
      and ( gi_LastFormFieldsHeight > CST_XML_DETAIL_MINHEIGHT) Then
        with afws_Source do
          Begin
            gi_LastFormFieldsHeight := 0;
            gi_LastFormColumnHeight := 0;
            gwin_Last := nil;
            awin_last := nil;
            ab_Column:=False;
            FPage := PageControlDetails;
            gwin_Parent := fscb_CreateTabSheet ( FPage, PanelDetails, gwin_Parent,
                             CST_COMPONENTS_DETAILS + IntToStr ( ai_FieldCounter )+ '_' +IntToStr ( afws_Source.Index ),
                             {$IFNDEF FPC}UTF8Decode{$ENDIF}( Gs_DetailsSheet ),Self);
            PageControlDetails:=FPage;
            awin_parent:=gwin_Parent;
            afws_Source.Panels.add.Panel := gwin_Parent;
          End;

      // The created control must be set and placed

      Result := True;

      // set name of control
      p_setControlNameAndTag( awin_Control,'con_'+anod_Field.NodeName, anod_Field.Attributes[CST_LEON_ID], awin_Parent, ai_FieldCounter, afws_Source.Index);

      // placing top of control
      if awin_parent is TGroupBox // can be a structured field in another table
       Then p_setFieldComponentTop ( awin_Control, awin_last, ab_Column )
       Else p_setFieldComponentTop ( awin_Control, gi_LastFormColumnHeight,gi_LastFormFieldsHeight-gi_LastFormColumnHeight, ab_Column );

      // optional data link
      p_setFieldComponentData ( awin_Control, afws_Source, lffd_ColumnFieldDef, lb_IsLocal );

      // adding optional label
      llab_Label := flab_setFieldComponentProperties ( anod_Field, awin_Control, awin_Parent, afws_Source.Index, ab_Column, lffd_ColumnFieldDef );

      // placing left of control
      if assigned ( llab_Label )
       Then p_setLabelComponent ( awin_Control, llab_Label, ab_Column )
       Else p_setComponentLeftWidth  ( awin_Control, ab_Column );
      if lb_IsLocal Then
       Begin
         // setting name of no data control sets text property
         p_SetComponentProperty(awin_Control,CST_PROPERTY_TEXT,'');
         // no local definition
         afws_Source.FieldsDefs.Delete(lffd_ColumnFieldDef.Index);
       end;

    end;
begin
   Result := nil;
  // Initing fb_CreateComponents
  lxfc_ButtonCombo := nil;
  // Placing the created control
  if fb_CreateComponents ( Result )  Then
    if assigned ( Result ) Then
      Begin

        // setting width of control amd parent
        p_SetControlAndParentWidth ( Result, awin_parent );
        // setting parent widths
        if not ( awin_Parent is TGroupBox ) Then
          Begin
            // next ab_column
            ab_Column := Result.Width + Result.Left < CST_XML_SEGUND_COLUMN_MIN_POSWIDTH;
            // setting form scroll width
            if FPanelMain.Left + DBSources [ 0 ].Grid.Width + Result.Left + Result.Width > Width then
              Width := FPanelMain.Left + DBSources [ 0 ].Grid.Width + Result.Left + Result.Width;
            gi_LastFormColumnHeight := gi_LastFormFieldsHeight;
            if gi_LastFormFieldsHeight < Result.Top + Result.Height then
              Begin
                gi_LastFormFieldsHeight := Result.Top + Result.Height ;
                // setting form scroll height
                if FPanelMain.Top + FActionPanel.Height + Result.Top + Result.Height > Height then
                  Height := FPanelMain.Top + Result.Top + FActionPanel.Height + Result.Height;

              End;
          end ;

      end;
  // there is a routine in FillComboButton to place its button
  if assigned ( lxfc_ButtonCombo ) Then
    lxfc_ButtonCombo.AutoPlace;

end;


// procedure p_CreateFormComponents
// Create a form from XML File
// as_XMLFile : XML File
// as_Name : Name of form
// awin_Parent : Parent component
// ai_Counter : The column counter for other XML File
procedure TF_XMLForm.p_CreateFormComponents ( const as_XMLClass, as_Name : String ; awin_Parent : TWinControl );
begin
  // For actions at the end of xml file
   gi_LastFormFieldsHeight := 0;
   gwin_Parent:=awin_Parent;
   gwin_Last := nil;
   p_CreateComponents ( DBSOurces,as_XMLClass,as_Name,Self,awin_Parent,gxdo_FichierXML,
                        TOnExecuteFieldNode(p_OnCreateParentAndFieldsComponent),
                        TOnExecuteFieldNode(p_OnFieldsButtonsComponents),
                        TOnExecuteNode(p_OncolumnNameNode ));
end;



// overrided procedure BeforeCreateFrameWork
// Creating invisible component and setting it
// Sender : needed
procedure TF_XMLForm.BeforeCreateFrameWork(Sender: TComponent);
begin
  gfin_FormIni := TOnFormInfoIni.Create(Self);
  gfin_FormIni.SaveEdits   := [feTGrid,feTVirtualTrees,feTListView];
  gfin_FormIni.SaveForm    := [sfSameMonitor,sfSavePos,sfSaveSize,sfSaveSizes];
  gfin_FormIni.Name := CST_COMPONENTS_FORMINI;
  gfin_FormIni.Options := [loAutoUpdate,loFreeIni];
  DBCloseMessage := True;
end;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TXMLForm );
{$ENDIF}
end.


