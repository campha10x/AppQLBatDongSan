using System;
namespace BatDongSanAPI.Models
{
    public class HoaDon
    {
        private BatDongSanStoreContext context;


        public string IdHoaDon { get; set; }

        public string IdPhong  { get; set; }

        public string SoPhieu { get; set; }

        public string NgayTao { get; set; }

        public string SoTien { get; set; }

        public string DaTra { get; set; }
    }

    public class HoaDon_Phong {

        private BatDongSanStoreContext context;

        public string IdHoaDon { get; set; }

        public string IdPhong { get; set; }

        public string SoPhieu { get; set; }

        public string NgayTao { get; set; }

        public string SoTien { get; set; }

        public string DaTra { get; set; }


        public string TenPhong { get; set; }

        public string DonGia { get; set; }

        public string SoDien { get; set; }

        public string SoNuoc { get; set; }
    }

}
