unit Gizmos.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.ImageList,
  System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.Buttons, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.TitleBarCtrls,
  Vcl.ActnList, Vcl.StdActns,
  Eventbus,
  Gizmos.Events, Gizmos.Forms, Qodelib.NavigationView, i18nCore,
  i18nLocalizer;

type
  TwMainForm = class(TForm)
    vilLargeIcons: TVirtualImageList;
    vilIcons: TVirtualImageList;
    svSplitView: TSplitView;
    pnl1: TPanel;
    imBurgerButton: TVirtualImage;
    nvHeader: TQzNavigationView;
    nvFooter: TQzNavigationView;
    trTranslator: TTranslator;
    alActions: TActionList;
    acSectionWelcome: TAction;
    acSectionSettings: TAction;
    nvModules: TQzNavigationView;
    viModuleIcons: TVirtualImageList;
    procedure FormCreate(Sender: TObject);
    procedure imBurgerButtonClick(Sender: TObject);
    procedure acSectionWelcomeExecute(Sender: TObject);
    procedure acSectionSettingsExecute(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure nvFooterButtonClicked(Sender: TObject; Index: Integer);
    procedure nvModulesButtonClicked(Sender: TObject; Index: Integer);
    procedure nvHeaderButtonClicked(Sender: TObject; Index: Integer);
    procedure svSplitViewClosed(Sender: TObject);
    procedure svSplitViewOpened(Sender: TObject);
  private
    FForms: TApplicationFormList;
    procedure InitSettings;
    procedure WMSettingChange(var Message: TWMSettingChange); message WM_SETTINGCHANGE;
  protected
    property Forms: TApplicationFormList read FForms;
  public
  end;

var
  wMainForm: TwMainForm;

implementation

{$R *.dfm}

uses
  Gizmos.DataModule, Gizmos.Settings, Gizmos.About;

{ TwMain }

procedure TwMainForm.acHelpAboutExecute(Sender: TObject);
begin
  TwAbout.ExecuteDialog;
end;

procedure TwMainForm.acSectionSettingsExecute(Sender: TObject);
begin
  FForms.ShowForm(qftSettings);
end;

procedure TwMainForm.acSectionWelcomeExecute(Sender: TObject);
begin
  FForms.ShowForm(qftWelcome);
end;

procedure TwMainForm.FormCreate(Sender: TObject);
begin
  FForms := TApplicationFormList.Create(self);
  acSectionWelcome.Execute;
//  GlobalEventBus.RegisterSubscriberForEvents(Self);
  dmCommon.MainFormCreated;
  InitSettings;
end;

procedure TwMainForm.FormDestroy(Sender: TObject);
begin
  ApplicationSettings.FormPosition.SavePosition(self);
  FForms.Free;
end;

procedure TwMainForm.imBurgerButtonClick(Sender: TObject);
begin
  svSplitView.Opened := not svSplitView.Opened;
end;

procedure TwMainForm.InitSettings;
begin
  svSplitView.Opened := ApplicationSettings.DrawerOpened;
  ApplicationSettings.FormPosition.LoadPosition(self);
end;

procedure TwMainForm.nvFooterButtonClicked(Sender: TObject; Index: Integer);
begin
  nvHeader.ItemIndex := -1;
  nvModules.ItemIndex := -1;
end;

procedure TwMainForm.nvModulesButtonClicked(Sender: TObject; Index: Integer);
begin
  nvHeader.ItemIndex := -1;
  nvFooter.ItemIndex := -1;
end;

procedure TwMainForm.nvHeaderButtonClicked(Sender: TObject; Index: Integer);
begin
  nvFooter.ItemIndex := -1;
  nvModules.ItemIndex := -1;
end;

procedure TwMainForm.svSplitViewClosed(Sender: TObject);
begin
  ApplicationSettings.DrawerOpened := false;
  nvHeader.ButtonOptions := nvHeader.ButtonOptions - [nboShowCaptions];
  nvFooter.ButtonOptions := nvFooter.ButtonOptions - [nboShowCaptions];
  nvModules.ButtonOptions := nvModules.ButtonOptions - [nboShowCaptions];
end;

procedure TwMainForm.svSplitViewOpened(Sender: TObject);
begin
  ApplicationSettings.DrawerOpened := true;
  nvHeader.ButtonOptions := nvHeader.ButtonOptions + [nboShowCaptions];
  nvFooter.ButtonOptions := nvFooter.ButtonOptions + [nboShowCaptions];
  nvModules.ButtonOptions := nvModules.ButtonOptions + [nboShowCaptions];
end;

procedure TwMainForm.WMSettingChange(var Message: TWMSettingChange);
begin
  if SameText('ImmersiveColorSet', String(Message.Section)) then
    ApplicationSettings.WindowsThemeChanged;
end;

end.
