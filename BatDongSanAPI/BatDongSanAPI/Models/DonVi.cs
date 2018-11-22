using System;
namespace BatDongSanAPI.Models
{
    public class DonVi
    {
         private BatDongSanStoreContext context;
        public string idDonVi { get; set; }

        public string TenDonVi { get; set; }

        public string GhiChu { get; set; }
    }
}
