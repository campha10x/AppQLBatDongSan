using System;
namespace BatDongSanAPI.Models
{
    public class HopDong
    {
        private BatDongSanStoreContext context;

        public String IdHopDong { get; set; }
        public String ChuHopDong { get; set; }
        public String IdCanHo { get; set; }
        public String SoTienCoc { get; set; }
        public String NgayBD { get; set; }
        public String NgayKT { get; set; }
        public String GhiChu { get; set; }
        public String IdKhachHang { get; set; }
    }
}
