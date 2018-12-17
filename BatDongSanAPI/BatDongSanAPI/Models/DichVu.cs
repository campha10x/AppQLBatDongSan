using System;
namespace BatDongSanAPI.Models
{
    public class DichVu
    {
        private BatDongSanStoreContext context;


        public string IdDichVu { get; set; }

        public string TenDichVu { get; set; }


        public string DonVi { get; set; }
    }
}
