using System;
namespace BatDongSanAPI.Models
{
    public class HoaDon
    {
        private BatDongSanStoreContext context;


        public string IdHoaDon { get; set; }

        public string IdCanHo  { get; set; }

        public string SoPhieu { get; set; }

        public string NgayTao { get; set; }

        public string SoTien { get; set; }

        public string DaTra { get; set; }

        public string SoDienMoi { get; set; }

        public string SoNuocMoi { get; set; }

        public string IdPhieuThu { get; set; }
    }

    public class HoaDon_CanHo {

        private BatDongSanStoreContext context;
        // hoa don
        public string IdHoaDon { get; set; }

        public string IdCanHo { get; set; }

        public string SoPhieu { get; set; }

        public string NgayTao { get; set; }

        public string SoTien { get; set; }

        public string SoDienMoi { get; set; }

        public string SoNuocMoi { get; set; }

        public string DaTra { get; set; }

        public string IdPhieuThu { get; set; }

        // phong

        public string TenCanHo { get; set; }

        public string DonGia { get; set; }

        public string SoDien { get; set; }

        public string SoNuoc { get; set; }

        public string DienTich { get; set; }

        public string DiaChi { get; set; }
    }

}
