<%@ Import Namespace="Sitecore.Analytics"%>
<%@ Import Namespace="Sitecore.Analytics.Automation.Data"%>
<%@ Import Namespace="Sitecore.Analytics.Automation.MarketingAutomation"%>
<%@ Import Namespace="Sitecore.Data"%>
<%@ Page Language="c#" Inherits="System.Web.UI.Page" CodePage="65001" %>
<%@ Register TagPrefix="sc" Namespace="Sitecore.Web.UI.WebControls" Assembly="Sitecore.Kernel" %>
<%@ OutputCache Location="None" VaryByParam="none" %>
<!DOCTYPE html>
<script runat="server">
    
  
    protected void Button1_Click(object sender, EventArgs e)
    {
        Tracker.Current.CurrentPage.Session.Identify(TextBox1.Text);
        var facet = Tracker.Current.Contact.GetFacet<Sitecore.Analytics.Model.Entities.IContactPersonalInfo>("Personal");
        facet.FirstName = TextBox1.Text;

        Label2.Text = TextBox1.Text;
    }

    protected void Button5_Click(object sender, EventArgs e)
    {
        Session.Abandon();
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        Tracker.Current.Contact.AutomationStates().EnrollInEngagementPlan(new ID(TextBox2.Text), new ID(TextBox3.Text));      
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Label2.Text = "anonymous";

        if (!String.IsNullOrEmpty(Tracker.Current.Session.Contact.Identifiers.Identifier))
        {
            var facet = Tracker.Current.Session.Contact.GetFacet<Sitecore.Analytics.Model.Entities.IContactPersonalInfo>("Personal");
            if (facet != null)
            {
                if (String.IsNullOrEmpty(facet.FirstName))
                {
                    Label2.Text = "(empty First Name)";
                }
                else
                {
                    Label2.Text = facet.FirstName;
                }
            }
        }


    }
</script>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
  <title>Welcome to Sitecore</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="CODE_LANGUAGE" content="C#" />
  <meta name="vs_defaultClientScript" content="JavaScript" />
  <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />
  <link href="/default.css" rel="stylesheet" />
  <sc:VisitorIdentification runat="server" />
</head>
<body> 
  <form id="mainform" method="post" runat="server">
    <div id="MainPanel">
        <br />
        <asp:Label ID="Label1" runat="server" Text="Current contact: "></asp:Label>
        <asp:Label ID="Label2" runat="server" Text="anonymous"></asp:Label>
        <br />
        <br />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Identify as:" />
        &nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="TextBox1" runat="server" Width="127px">sitecore\\Kate</asp:TextBox>
        <br />
        <br />
        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Enroll in:" Width="94px" />
        &nbsp;&nbsp;&nbsp;
        <br />
        <asp:Label ID="Label3" runat="server" Text="Engagement Plan ID:"></asp:Label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="TextBox2" runat="server" Width="314px">{38C0F589-B70E-4504-9DCA-0C98EACBE9E8}</asp:TextBox>
        <br />
        <asp:Label ID="Label4" runat="server" Text="State in Engagement Plan ID:"></asp:Label>
&nbsp;<asp:TextBox ID="TextBox3" runat="server" Width="312px">{36659348-332A-4422-80E2-048E66A47EF5}</asp:TextBox>
        <br />
        <br />
        <asp:Button ID="Button5" runat="server" OnClick="Button5_Click" Text="End Session" />
        <br />
        <br />
      <sc:placeholder key="main" runat="server" /> 
        <br />
    </div>
  </form>
 </body>
</html>
