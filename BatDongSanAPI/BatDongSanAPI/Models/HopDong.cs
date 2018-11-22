using System;
namespace BatDongSanAPI.Models
{
    public class HopDong
    {
        private BatDongSanStoreContext context;

        public String idHopDong { get; set; }
        public String ChuHopDong { get; set; }
        public String idPhong { get; set; }
        public String SoTienCoc { get; set; }
        public String NgayBD { get; set; }
        public String NgayKT { get; set; }
        public String GhiChu { get; set; }
        public String GioiTinh { get; set; }
        public String SDTKhachHang { get; set; }
        public String EmailKhachHang { get; set; }
    }
}
