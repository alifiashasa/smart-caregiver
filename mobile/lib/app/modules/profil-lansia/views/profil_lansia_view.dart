import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_lansia_controller.dart';

class ProfilLansiaView extends GetView<ProfilLansiaController> {
  const ProfilLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.80),
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F4), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Profile Pasien',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 884),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 32),
              decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Obx(
                                          () => Container(
                                            width: 96,
                                            height: 96,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  controller.patientImage,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  width: 4,
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color(0x26A1A1AA),
                                                  blurRadius: 16,
                                                  offset: Offset(0, 4),
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 64,
                                          top: 64,
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFF192126),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: ShapeDecoration(
                                                      color: Colors.white
                                                          .withValues(alpha: 0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      shadows: const [
                                                        BoxShadow(
                                                          color: Color(
                                                            0x33000000,
                                                          ),
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2),
                                                          spreadRadius: -2,
                                                        ),
                                                        BoxShadow(
                                                          color: Color(
                                                            0x33000000,
                                                          ),
                                                          blurRadius: 6,
                                                          offset: Offset(0, 4),
                                                          spreadRadius: -1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Edit Profile',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                            height: 1.33,
                                            letterSpacing: -0.24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildProfileTabs(),
                        const SizedBox(height: 16),
                        // INFORMASI DASAR container
                        Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: controller.selectedProfileTab == 0
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x14A1A1AA),
                                          blurRadius: 16,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 310,
                                                      child: Text(
                                                        'INFORMASI DASAR',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF5D5E66,
                                                          ),
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.43,
                                                          letterSpacing: 0.70,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                ),
                                                child: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 306,
                                                            child: Text(
                                                              'Nama Lengkap',
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF47464B,
                                                                ),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 1.33,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    controller.namaController,
                                                style: const TextStyle(
                                                  color: Color(0xFF1C1B1C),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: const Color(
                                                    0xFFFDF8F8,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFFC8C5CB,
                                                              ),
                                                              width: 1,
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFF192126,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                      ),
                                                  isDense: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 4,
                                                          ),
                                                      child: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 143,
                                                                  child: Text(
                                                                    'Umur',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                        0xFF47464B,
                                                                      ),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      height:
                                                                          1.33,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: controller
                                                          .umurController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF1C1B1C,
                                                        ),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: const Color(
                                                          0xFFFDF8F8,
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 12,
                                                            ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFC8C5CB,
                                                                    ),
                                                                    width: 1,
                                                                  ),
                                                            ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFF192126,
                                                                    ),
                                                                    width: 1.5,
                                                                  ),
                                                            ),
                                                        isDense: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 4,
                                                          ),
                                                      child: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 143,
                                                                  child: Text(
                                                                    'Jenis Kelamin',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                        0xFF47464B,
                                                                      ),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      height:
                                                                          1.33,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: controller
                                                          .jenisKelaminController,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF1C1B1C,
                                                        ),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: const Color(
                                                          0xFFFDF8F8,
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 12,
                                                            ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFC8C5CB,
                                                                    ),
                                                                    width: 1,
                                                                  ),
                                                            ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFF192126,
                                                                    ),
                                                                    width: 1.5,
                                                                  ),
                                                            ),
                                                        isDense: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        // LATAR BELAKANG KESEHATAN container
                        Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: controller.selectedProfileTab == 1
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x14A1A1AA),
                                          blurRadius: 16,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 310,
                                                      child: Text(
                                                        'LATAR BELAKANG KESEHATAN',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF5D5E66,
                                                          ),
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                ),
                                                child: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 306,
                                                            child: Text(
                                                              'Riwayat Medis',
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF47464B,
                                                                ),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 1.33,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextField(
                                                controller: controller
                                                    .riwayatMedisController,
                                                style: const TextStyle(
                                                  color: Color(0xFF1C1B1C),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: const Color(
                                                    0xFFFDF8F8,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFFC8C5CB,
                                                              ),
                                                              width: 1,
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFF192126,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                      ),
                                                  isDense: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 4,
                                                          ),
                                                      child: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 306,
                                                                  child: Text(
                                                                    'Kondisi Fisik',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                        0xFF47464B,
                                                                      ),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      height:
                                                                          1.33,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Wrap(
                                                      runSpacing: 8,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFF192126,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFF192126,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Mandiri',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFFFDF8F8,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFFC8C5CB,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Butuh Bantuan Sebagian',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF1C1B1C,
                                                              ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFFFDF8F8,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFFC8C5CB,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Butuh Bantuan Penuh',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF1C1B1C,
                                                              ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 4,
                                                          ),
                                                      child: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 306,
                                                                  child: Text(
                                                                    'Tingkat Mobilitas',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                        0xFF47464B,
                                                                      ),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      height:
                                                                          1.33,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Wrap(
                                                      runSpacing: 8,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFFFDF8F8,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFFC8C5CB,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Bisa Berjalan',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF1C1B1C,
                                                              ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFFBBF246,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFFBBF246,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Alat Bantu',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF192126,
                                                              ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFFFDF8F8,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFFC8C5CB,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Kursi Roda',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF1C1B1C,
                                                              ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          decoration: ShapeDecoration(
                                                            color: const Color(
                                                              0xFFFDF8F8,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                  0xFFC8C5CB,
                                                                ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Berbaring',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF1C1B1C,
                                                              ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  0.14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        // PERSONAL & MINAT
                        Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: controller.selectedProfileTab == 2
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x14A1A1AA),
                                          blurRadius: 16,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 310,
                                                      child: Text(
                                                        'PERSONAL & MINAT',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF5D5E66,
                                                          ),
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.43,
                                                          letterSpacing: 0.70,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                ),
                                                child: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 306,
                                                            child: Text(
                                                              'Minat & Hobi',
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF47464B,
                                                                ),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 1.33,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextField(
                                                controller: controller
                                                    .minatHobiController,
                                                style: const TextStyle(
                                                  color: Color(0xFF1C1B1C),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: const Color(
                                                    0xFFFDF8F8,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFFC8C5CB,
                                                              ),
                                                              width: 1,
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFF192126,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                      ),
                                                  isDense: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        // Buttons at the bottom
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => InkWell(
                                  onTap: controller.isLoading
                                      ? null
                                      : controller.saveChanges,
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    width: double.infinity,
                                    height: 48,
                                    decoration: ShapeDecoration(
                                      color: controller.isLoading
                                          ? const Color(0xFF8C9093)
                                          : const Color(0xFF192126),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x0F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: controller.isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Simpan Perubahan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w500,
                                                height: 1.43,
                                                letterSpacing: 0.14,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.delete_outline,
                                                      size: 20,
                                                      color: Color(0xFFBA1A1A),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'Hapus Profile',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFFBA1A1A),
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.43,
                                                    letterSpacing: 0.14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTabs() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFF1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            _buildProfileTabItem(0, 'Dasar'),
            _buildProfileTabItem(1, 'Kesehatan'),
            _buildProfileTabItem(2, 'Minat'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTabItem(int index, String label) {
    final isSelected = controller.selectedProfileTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeProfileTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF192126) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF47464B),
              fontSize: 13,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
