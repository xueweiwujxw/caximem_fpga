//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Thu Sep 22 20:11:40 2022
//Host        : wlanxww-work running 64-bit Ubuntu 20.04.5 LTS
//Command     : generate_target zynq_top_wrapper.bd
//Design      : zynq_top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zynq_top_wrapper
   (DDR_0_addr,
    DDR_0_ba,
    DDR_0_cas_n,
    DDR_0_ck_n,
    DDR_0_ck_p,
    DDR_0_cke,
    DDR_0_cs_n,
    DDR_0_dm,
    DDR_0_dq,
    DDR_0_dqs_n,
    DDR_0_dqs_p,
    DDR_0_odt,
    DDR_0_ras_n,
    DDR_0_reset_n,
    DDR_0_we_n,
    ENET0_EXT_INTIN_0,
    FIXED_IO_0_ddr_vrn,
    FIXED_IO_0_ddr_vrp,
    FIXED_IO_0_mio,
    FIXED_IO_0_ps_clk,
    FIXED_IO_0_ps_porb,
    FIXED_IO_0_ps_srstb,
    GPIO_0_0_tri_io,
    MDIO_PHY_0_mdc,
    MDIO_PHY_0_mdio_io,
    RGMII_0_rd,
    RGMII_0_rx_ctl,
    RGMII_0_rxc,
    RGMII_0_td,
    RGMII_0_tx_ctl,
    RGMII_0_txc);
  inout [14:0]DDR_0_addr;
  inout [2:0]DDR_0_ba;
  inout DDR_0_cas_n;
  inout DDR_0_ck_n;
  inout DDR_0_ck_p;
  inout DDR_0_cke;
  inout DDR_0_cs_n;
  inout [3:0]DDR_0_dm;
  inout [31:0]DDR_0_dq;
  inout [3:0]DDR_0_dqs_n;
  inout [3:0]DDR_0_dqs_p;
  inout DDR_0_odt;
  inout DDR_0_ras_n;
  inout DDR_0_reset_n;
  inout DDR_0_we_n;
  input ENET0_EXT_INTIN_0;
  inout FIXED_IO_0_ddr_vrn;
  inout FIXED_IO_0_ddr_vrp;
  inout [53:0]FIXED_IO_0_mio;
  inout FIXED_IO_0_ps_clk;
  inout FIXED_IO_0_ps_porb;
  inout FIXED_IO_0_ps_srstb;
  inout [1:0]GPIO_0_0_tri_io;
  output MDIO_PHY_0_mdc;
  inout MDIO_PHY_0_mdio_io;
  input [3:0]RGMII_0_rd;
  input RGMII_0_rx_ctl;
  input RGMII_0_rxc;
  output [3:0]RGMII_0_td;
  output RGMII_0_tx_ctl;
  output RGMII_0_txc;

  wire [14:0]DDR_0_addr;
  wire [2:0]DDR_0_ba;
  wire DDR_0_cas_n;
  wire DDR_0_ck_n;
  wire DDR_0_ck_p;
  wire DDR_0_cke;
  wire DDR_0_cs_n;
  wire [3:0]DDR_0_dm;
  wire [31:0]DDR_0_dq;
  wire [3:0]DDR_0_dqs_n;
  wire [3:0]DDR_0_dqs_p;
  wire DDR_0_odt;
  wire DDR_0_ras_n;
  wire DDR_0_reset_n;
  wire DDR_0_we_n;
  wire ENET0_EXT_INTIN_0;
  wire FIXED_IO_0_ddr_vrn;
  wire FIXED_IO_0_ddr_vrp;
  wire [53:0]FIXED_IO_0_mio;
  wire FIXED_IO_0_ps_clk;
  wire FIXED_IO_0_ps_porb;
  wire FIXED_IO_0_ps_srstb;
  wire [0:0]GPIO_0_0_tri_i_0;
  wire [1:1]GPIO_0_0_tri_i_1;
  wire [0:0]GPIO_0_0_tri_io_0;
  wire [1:1]GPIO_0_0_tri_io_1;
  wire [0:0]GPIO_0_0_tri_o_0;
  wire [1:1]GPIO_0_0_tri_o_1;
  wire [0:0]GPIO_0_0_tri_t_0;
  wire [1:1]GPIO_0_0_tri_t_1;
  wire MDIO_PHY_0_mdc;
  wire MDIO_PHY_0_mdio_i;
  wire MDIO_PHY_0_mdio_io;
  wire MDIO_PHY_0_mdio_o;
  wire MDIO_PHY_0_mdio_t;
  wire [3:0]RGMII_0_rd;
  wire RGMII_0_rx_ctl;
  wire RGMII_0_rxc;
  wire [3:0]RGMII_0_td;
  wire RGMII_0_tx_ctl;
  wire RGMII_0_txc;

  wire c2h_irpt;
  wire [15:0]c2h_maxi_araddr;
  wire [1:0]c2h_maxi_arburst;
  wire [3:0]c2h_maxi_arcache;
  wire [7:0]c2h_maxi_arlen;
  wire [0:0]c2h_maxi_arlock;
  wire [2:0]c2h_maxi_arprot;
  wire [3:0]c2h_maxi_arqos;
  wire c2h_maxi_arready;
  wire [2:0]c2h_maxi_arsize;
  wire c2h_maxi_arvalid;
  wire [15:0]c2h_maxi_awaddr;
  wire [1:0]c2h_maxi_awburst;
  wire [3:0]c2h_maxi_awcache;
  wire [7:0]c2h_maxi_awlen;
  wire [0:0]c2h_maxi_awlock;
  wire [2:0]c2h_maxi_awprot;
  wire [3:0]c2h_maxi_awqos;
  wire c2h_maxi_awready;
  wire [2:0]c2h_maxi_awsize;
  wire c2h_maxi_awvalid;
  wire c2h_maxi_bready;
  wire [1:0]c2h_maxi_bresp;
  wire c2h_maxi_bvalid;
  wire [31:0]c2h_maxi_rdata;
  wire c2h_maxi_rlast;
  wire c2h_maxi_rready;
  wire [1:0]c2h_maxi_rresp;
  wire c2h_maxi_rvalid;
  wire [31:0]c2h_maxi_wdata;
  wire c2h_maxi_wlast;
  wire c2h_maxi_wready;
  wire [3:0]c2h_maxi_wstrb;
  wire c2h_maxi_wvalid;
  wire h2c_irpt;
  wire [15:0]h2c_maxi_araddr;
  wire [1:0]h2c_maxi_arburst;
  wire [3:0]h2c_maxi_arcache;
  wire [7:0]h2c_maxi_arlen;
  wire [0:0]h2c_maxi_arlock;
  wire [2:0]h2c_maxi_arprot;
  wire [3:0]h2c_maxi_arqos;
  wire h2c_maxi_arready;
  wire [2:0]h2c_maxi_arsize;
  wire h2c_maxi_arvalid;
  wire [15:0]h2c_maxi_awaddr;
  wire [1:0]h2c_maxi_awburst;
  wire [3:0]h2c_maxi_awcache;
  wire [7:0]h2c_maxi_awlen;
  wire [0:0]h2c_maxi_awlock;
  wire [2:0]h2c_maxi_awprot;
  wire [3:0]h2c_maxi_awqos;
  wire h2c_maxi_awready;
  wire [2:0]h2c_maxi_awsize;
  wire h2c_maxi_awvalid;
  wire h2c_maxi_bready;
  wire [1:0]h2c_maxi_bresp;
  wire h2c_maxi_bvalid;
  wire [31:0]h2c_maxi_rdata;
  wire h2c_maxi_rlast;
  wire h2c_maxi_rready;
  wire [1:0]h2c_maxi_rresp;
  wire h2c_maxi_rvalid;
  wire [31:0]h2c_maxi_wdata;
  wire h2c_maxi_wlast;
  wire h2c_maxi_wready;
  wire [3:0]h2c_maxi_wstrb;
  wire h2c_maxi_wvalid;

  wire loopback_stream_tvalid;
  wire loopback_stream_tready;
  wire loopback_stream_tlast;
  wire [31:0]loopback_stream_tdata;
  wire [3:0]loopback_stream_tkeep;
  wire peripheral_reset_0;
  wire FCLK_CLK1_0;

  IOBUF GPIO_0_0_tri_iobuf_0
       (.I(GPIO_0_0_tri_o_0),
        .IO(GPIO_0_0_tri_io[0]),
        .O(GPIO_0_0_tri_i_0),
        .T(GPIO_0_0_tri_t_0));
  IOBUF GPIO_0_0_tri_iobuf_1
       (.I(GPIO_0_0_tri_o_1),
        .IO(GPIO_0_0_tri_io[1]),
        .O(GPIO_0_0_tri_i_1),
        .T(GPIO_0_0_tri_t_1));
  IOBUF MDIO_PHY_0_mdio_iobuf
       (.I(MDIO_PHY_0_mdio_o),
        .IO(MDIO_PHY_0_mdio_io),
        .O(MDIO_PHY_0_mdio_i),
        .T(MDIO_PHY_0_mdio_t));
  zynq_top zynq_top_i
       (.DDR_0_addr(DDR_0_addr),
        .DDR_0_ba(DDR_0_ba),
        .DDR_0_cas_n(DDR_0_cas_n),
        .DDR_0_ck_n(DDR_0_ck_n),
        .DDR_0_ck_p(DDR_0_ck_p),
        .DDR_0_cke(DDR_0_cke),
        .DDR_0_cs_n(DDR_0_cs_n),
        .DDR_0_dm(DDR_0_dm),
        .DDR_0_dq(DDR_0_dq),
        .DDR_0_dqs_n(DDR_0_dqs_n),
        .DDR_0_dqs_p(DDR_0_dqs_p),
        .DDR_0_odt(DDR_0_odt),
        .DDR_0_ras_n(DDR_0_ras_n),
        .DDR_0_reset_n(DDR_0_reset_n),
        .DDR_0_we_n(DDR_0_we_n),
        .ENET0_EXT_INTIN_0(ENET0_EXT_INTIN_0),
        .FIXED_IO_0_ddr_vrn(FIXED_IO_0_ddr_vrn),
        .FIXED_IO_0_ddr_vrp(FIXED_IO_0_ddr_vrp),
        .FIXED_IO_0_mio(FIXED_IO_0_mio),
        .FIXED_IO_0_ps_clk(FIXED_IO_0_ps_clk),
        .FIXED_IO_0_ps_porb(FIXED_IO_0_ps_porb),
        .FIXED_IO_0_ps_srstb(FIXED_IO_0_ps_srstb),
        .GPIO_0_0_tri_i({GPIO_0_0_tri_i_1,GPIO_0_0_tri_i_0}),
        .GPIO_0_0_tri_o({GPIO_0_0_tri_o_1,GPIO_0_0_tri_o_0}),
        .GPIO_0_0_tri_t({GPIO_0_0_tri_t_1,GPIO_0_0_tri_t_0}),
        .MDIO_PHY_0_mdc(MDIO_PHY_0_mdc),
        .MDIO_PHY_0_mdio_i(MDIO_PHY_0_mdio_i),
        .MDIO_PHY_0_mdio_o(MDIO_PHY_0_mdio_o),
        .MDIO_PHY_0_mdio_t(MDIO_PHY_0_mdio_t),
        .RGMII_0_rd(RGMII_0_rd),
        .RGMII_0_rx_ctl(RGMII_0_rx_ctl),
        .RGMII_0_rxc(RGMII_0_rxc),
        .RGMII_0_td(RGMII_0_td),
        .RGMII_0_tx_ctl(RGMII_0_tx_ctl),
        .RGMII_0_txc(RGMII_0_txc),
        .FCLK_CLK1_0(FCLK_CLK1_0),
        .peripheral_reset_0(peripheral_reset_0),
        .c2h_irpt(c2h_irpt),
        .c2h_maxi_araddr(c2h_maxi_araddr),
        .c2h_maxi_arburst(c2h_maxi_arburst),
        .c2h_maxi_arcache(c2h_maxi_arcache),
        .c2h_maxi_arlen(c2h_maxi_arlen),
        .c2h_maxi_arlock(c2h_maxi_arlock),
        .c2h_maxi_arprot(c2h_maxi_arprot),
        .c2h_maxi_arqos(c2h_maxi_arqos),
        .c2h_maxi_arready(c2h_maxi_arready),
        .c2h_maxi_arsize(c2h_maxi_arsize),
        .c2h_maxi_arvalid(c2h_maxi_arvalid),
        .c2h_maxi_awaddr(c2h_maxi_awaddr),
        .c2h_maxi_awburst(c2h_maxi_awburst),
        .c2h_maxi_awcache(c2h_maxi_awcache),
        .c2h_maxi_awlen(c2h_maxi_awlen),
        .c2h_maxi_awlock(c2h_maxi_awlock),
        .c2h_maxi_awprot(c2h_maxi_awprot),
        .c2h_maxi_awqos(c2h_maxi_awqos),
        .c2h_maxi_awready(c2h_maxi_awready),
        .c2h_maxi_awsize(c2h_maxi_awsize),
        .c2h_maxi_awvalid(c2h_maxi_awvalid),
        .c2h_maxi_bready(c2h_maxi_bready),
        .c2h_maxi_bresp(c2h_maxi_bresp),
        .c2h_maxi_bvalid(c2h_maxi_bvalid),
        .c2h_maxi_rdata(c2h_maxi_rdata),
        .c2h_maxi_rlast(c2h_maxi_rlast),
        .c2h_maxi_rready(c2h_maxi_rready),
        .c2h_maxi_rresp(c2h_maxi_rresp),
        .c2h_maxi_rvalid(c2h_maxi_rvalid),
        .c2h_maxi_wdata(c2h_maxi_wdata),
        .c2h_maxi_wlast(c2h_maxi_wlast),
        .c2h_maxi_wready(c2h_maxi_wready),
        .c2h_maxi_wstrb(c2h_maxi_wstrb),
        .c2h_maxi_wvalid(c2h_maxi_wvalid),
        .h2c_irpt(h2c_irpt),
        .h2c_maxi_araddr(h2c_maxi_araddr),
        .h2c_maxi_arburst(h2c_maxi_arburst),
        .h2c_maxi_arcache(h2c_maxi_arcache),
        .h2c_maxi_arlen(h2c_maxi_arlen),
        .h2c_maxi_arlock(h2c_maxi_arlock),
        .h2c_maxi_arprot(h2c_maxi_arprot),
        .h2c_maxi_arqos(h2c_maxi_arqos),
        .h2c_maxi_arready(h2c_maxi_arready),
        .h2c_maxi_arsize(h2c_maxi_arsize),
        .h2c_maxi_arvalid(h2c_maxi_arvalid),
        .h2c_maxi_awaddr(h2c_maxi_awaddr),
        .h2c_maxi_awburst(h2c_maxi_awburst),
        .h2c_maxi_awcache(h2c_maxi_awcache),
        .h2c_maxi_awlen(h2c_maxi_awlen),
        .h2c_maxi_awlock(h2c_maxi_awlock),
        .h2c_maxi_awprot(h2c_maxi_awprot),
        .h2c_maxi_awqos(h2c_maxi_awqos),
        .h2c_maxi_awready(h2c_maxi_awready),
        .h2c_maxi_awsize(h2c_maxi_awsize),
        .h2c_maxi_awvalid(h2c_maxi_awvalid),
        .h2c_maxi_bready(h2c_maxi_bready),
        .h2c_maxi_bresp(h2c_maxi_bresp),
        .h2c_maxi_bvalid(h2c_maxi_bvalid),
        .h2c_maxi_rdata(h2c_maxi_rdata),
        .h2c_maxi_rlast(h2c_maxi_rlast),
        .h2c_maxi_rready(h2c_maxi_rready),
        .h2c_maxi_rresp(h2c_maxi_rresp),
        .h2c_maxi_rvalid(h2c_maxi_rvalid),
        .h2c_maxi_wdata(h2c_maxi_wdata),
        .h2c_maxi_wlast(h2c_maxi_wlast),
        .h2c_maxi_wready(h2c_maxi_wready),
        .h2c_maxi_wstrb(h2c_maxi_wstrb),
        .h2c_maxi_wvalid(h2c_maxi_wvalid));

  CAxiMemTransfer trans
       (.h2c_axi_awvalid(h2c_maxi_awvalid),
        .h2c_axi_awready(h2c_maxi_awready),
        .h2c_axi_awaddr(h2c_maxi_awaddr),
        .h2c_axi_awlen(h2c_maxi_awlen),
        .h2c_axi_awsize(h2c_maxi_awsize),
        .h2c_axi_awburst(h2c_maxi_awburst),
        .h2c_axi_awlock(h2c_maxi_awlock),
        .h2c_axi_awcache(h2c_maxi_awcache),
        .h2c_axi_awqos(h2c_maxi_awqos),
        .h2c_axi_awprot(h2c_maxi_awprot),
        .h2c_axi_wvalid(h2c_maxi_wvalid),
        .h2c_axi_wready(h2c_maxi_wready),
        .h2c_axi_wdata(h2c_maxi_wdata),
        .h2c_axi_wstrb(h2c_maxi_wstrb),
        .h2c_axi_wlast(h2c_maxi_wlast),
        .h2c_axi_bvalid(h2c_maxi_bvalid),
        .h2c_axi_bready(h2c_maxi_bready),
        .h2c_axi_bresp(h2c_maxi_bresp),
        .h2c_axi_arvalid(h2c_maxi_arvalid),
        .h2c_axi_arready(h2c_maxi_arready),
        .h2c_axi_araddr(h2c_maxi_araddr),
        .h2c_axi_arlen(h2c_maxi_arlen),
        .h2c_axi_arsize(h2c_maxi_arsize),
        .h2c_axi_arburst(h2c_maxi_arburst),
        .h2c_axi_arlock(h2c_maxi_arlock),
        .h2c_axi_arcache(h2c_maxi_arcache),
        .h2c_axi_arqos(h2c_maxi_arqos),
        .h2c_axi_arprot(h2c_maxi_arprot),
        .h2c_axi_rvalid(h2c_maxi_rvalid),
        .h2c_axi_rready(h2c_maxi_rready),
        .h2c_axi_rdata(h2c_maxi_rdata),
        .h2c_axi_rresp(h2c_maxi_rresp),
        .h2c_axi_rlast(h2c_maxi_rlast),
        .c2h_axi_awvalid(c2h_maxi_awvalid),
        .c2h_axi_awready(c2h_maxi_awready),
        .c2h_axi_awaddr(c2h_maxi_awaddr),
        .c2h_axi_awlen(c2h_maxi_awlen),
        .c2h_axi_awsize(c2h_maxi_awsize),
        .c2h_axi_awburst(c2h_maxi_awburst),
        .c2h_axi_awlock(c2h_maxi_awlock),
        .c2h_axi_awcache(c2h_maxi_awcache),
        .c2h_axi_awqos(c2h_maxi_awqos),
        .c2h_axi_awprot(c2h_maxi_awprot),
        .c2h_axi_wvalid(c2h_maxi_wvalid),
        .c2h_axi_wready(c2h_maxi_wready),
        .c2h_axi_wdata(c2h_maxi_wdata),
        .c2h_axi_wstrb(c2h_maxi_wstrb),
        .c2h_axi_wlast(c2h_maxi_wlast),
        .c2h_axi_bvalid(c2h_maxi_bvalid),
        .c2h_axi_bready(c2h_maxi_bready),
        .c2h_axi_bresp(c2h_maxi_bresp),
        .c2h_axi_arvalid(c2h_maxi_arvalid),
        .c2h_axi_arready(c2h_maxi_arready),
        .c2h_axi_araddr(c2h_maxi_araddr),
        .c2h_axi_arlen(c2h_maxi_arlen),
        .c2h_axi_arsize(c2h_maxi_arsize),
        .c2h_axi_arburst(c2h_maxi_arburst),
        .c2h_axi_arlock(c2h_maxi_arlock),
        .c2h_axi_arcache(c2h_maxi_arcache),
        .c2h_axi_arqos(c2h_maxi_arqos),
        .c2h_axi_arprot(c2h_maxi_arprot),
        .c2h_axi_rvalid(c2h_maxi_rvalid),
        .c2h_axi_rready(c2h_maxi_rready),
        .c2h_axi_rdata(c2h_maxi_rdata),
        .c2h_axi_rresp(c2h_maxi_rresp),
        .c2h_axi_rlast(c2h_maxi_rlast),
        .h2c_axis_tvalid(loopback_stream_tvalid),
        .h2c_axis_tready(loopback_stream_tready),
        .h2c_axis_tdata(loopback_stream_tdata),
        .h2c_axis_tkeep(loopback_stream_tkeep),
        .h2c_axis_tlast(loopback_stream_tlast),
        .c2h_axis_tvalid(loopback_stream_tvalid),
        .c2h_axis_tready(loopback_stream_tready),
        .c2h_axis_tdata(loopback_stream_tdata),
        .c2h_axis_tkeep(loopback_stream_tkeep),
        .c2h_axis_tlast(loopback_stream_tlast),
        .h2c_irq(h2c_irpt),
        .c2h_irq(c2h_irpt),
        .clk(FCLK_CLK1_0),
        .reset(peripheral_reset_0));

endmodule
