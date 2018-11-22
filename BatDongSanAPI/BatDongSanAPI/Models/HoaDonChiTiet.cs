using System;
namespace BatDongSanAPI.Models
{
    public class HoaDonChiTiet
    {
        private BatDongSanStoreContext context;

        public int idHoaDonChiTiet { get; set; }
        public int idHoaDon { get; set; }
        public String Dichvu { get; set; }
        public String DonViTinh { get; set; }
        public int SoCu { get; set; }
        public int SoMoi { get; set; }
        public int SoLuong { get; set; }
        public decimal DonGia { get; set; }
    }
}
