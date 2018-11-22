using System;
namespace BatDongSanAPI.Models
{
    public class DichVu
    {
        private BatDongSanStoreContext context;


        public string idDichVu { get; set; }

        public string TenDichVu { get; set; }

        public string DonGia { get; set; }

        public string idDonvi { get; set; }

        public string MacDinh { get; set; }
    }
}
