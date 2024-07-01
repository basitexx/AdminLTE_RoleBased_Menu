using ProjectMain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjectMain.Account
{
    /// <summary>
    /// Summary description for PhotoProfile
    /// </summary>
    public class PhotoProfile : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var hawi_context = new hawic_dbEntities();
            //storing the querystring value that comes from Default aspx page  
            int imageId = Convert.ToInt32(context.Request.QueryString["id_Image"]);//.ToString();
            //retrieving the images on the basis of id of uploaded  
            // images, by using the query sting values which comes from Defaut.aspx page  
            byte[] Photo = hawi_context.tbl_Staff.FirstOrDefault(p => p.ID == imageId).Photo;
            //SqlDataReader dr = com.ExecuteReade();
            //dr.Read(); dr[0]
            context.Response.BinaryWrite((Byte[])Photo);
            context.Response.End();

            hawi_context.Dispose();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}