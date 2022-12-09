unit Blackholes.SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Eventbus,
  Blackholes.Forms, Blackholes.Events;

type
  TwSettingsForm = class(TApplicationForm)
    txTheme: TLabel;
    cbTheme: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cbThemeChange(Sender: TObject);
  private
    procedure LoadValues;
    procedure InitControls;
  public
  end;

implementation

{$R *.dfm}

uses
  Qodelib.Themes,
  Blackholes.Settings;

{ TwSettingsForm }

procedure TwSettingsForm.cbThemeChange(Sender: TObject);
begin
  ApplicationSettings.Theme := cbTheme.Items[cbTheme.ItemIndex];
end;

procedure TwSettingsForm.FormCreate(Sender: TObject);
begin
  InitControls;
  LoadValues;
end;

procedure TwSettingsForm.InitControls;
begin

end;

procedure TwSettingsForm.LoadValues;
begin
  QuarkzThemeManager.AssignThemeNames(cbTheme.Items);
  cbTheme.ItemIndex := cbTheme.Items.IndexOf(ApplicationSettings.Theme);
end;

end.