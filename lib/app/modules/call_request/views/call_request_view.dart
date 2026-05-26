import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/call_request_controller.dart';

class CallRequestView extends GetView<CallRequestController> {
  const CallRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 background
      appBar: AppBar(
        title: const Text(
          'Schedule a Call',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final dates = controller.availableDates;
          if (dates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step 1: Date Selector
                      const Text(
                        '1. SELECT DATE (NEXT 3 DAYS)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: dates.map((date) {
                          final isSelected = DateUtils.isSameDay(
                            controller.selectedDate.value,
                            date,
                          );
                          final isToday = DateUtils.isSameDay(
                            DateTime.now(),
                            date,
                          );

                          String label = isToday
                              ? 'Today'
                              : DateFormat('EEE, MMM d').format(date);

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.selectedDate.value = date;
                                  controller.selectedSlot.value =
                                      null; // Reset selection
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(
                                            0xFFEEF2FF,
                                          ) // Light Indigo
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF4F46E5) // Indigo
                                          : const Color(0xFFE2E8F0),
                                      width: isSelected ? 2.0 : 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        label,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isSelected
                                              ? const Color(0xFF4F46E5)
                                              : const Color(0xFF1E293B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 28),

                      // Step 2: Slot Selector
                      const Text(
                        '2. SELECT 30-MIN TIME SLOT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() => _buildSlotsGrid()),

                      const SizedBox(height: 28),

                      // Step 3: Note Field
                      const Text(
                        '3. ADD A NOTE (OPTIONAL)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.noteController,
                        maxLength: 140,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Describe what you would like to discuss (e.g. adjust posture, diet changes...)',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F46E5),
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom CTA Row
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: ElevatedButton(
                  onPressed: () => controller.submitCallRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Request Call',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSlotsGrid() {
    final slots = controller.generateSlotsForDate(
      controller.selectedDate.value,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];

        return Obx(() {
          final isPast = controller.isSlotInPast(slot);
          final isConflict = controller.isSlotConflict(slot);

          final isSelected =
              controller.selectedSlot.value?.millisecondsSinceEpoch ==
              slot.millisecondsSinceEpoch;

          final formattedTime = DateFormat('h:mm a').format(slot);

          Color boxColor = Colors.white;
          Color textColor = const Color(0xFF1E293B);
          Color borderColor = const Color(0xFFE2E8F0);
          double borderWidth = 1.5;

          if (isPast) {
            boxColor = const Color(0xFFF1F5F9);
            textColor = const Color(0xFF94A3B8);
          } else if (isConflict) {
            boxColor = const Color(0xFFFEF2F2);
            textColor = const Color(0xFFEF4444);
            borderColor = const Color(0xFFFCA5A5);
          } else if (isSelected) {
            boxColor = const Color(0xFFEEF2FF);
            textColor = const Color(0xFF4F46E5);
            borderColor = const Color(0xFF4F46E5);
            borderWidth = 2.0;
          }

          return InkWell(
            onTap: isPast || isConflict
                ? () {
                    if (isPast) {
                      Get.snackbar(
                        'Past Slot',
                        'This slot has already passed.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFEF2F2),
                        colorText: const Color(0xFF991B1B),
                      );
                    } else {
                      Get.snackbar(
                        'Slot Booked',
                        'This slot has already been approved for another session.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFEF2F2),
                        colorText: const Color(0xFF991B1B),
                      );
                    }
                  }
                : () {
                    controller.selectedSlot.value = slot;
                  },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: borderWidth),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textColor,
                      decoration: isPast ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (isConflict)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'Booked',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Widget _buildSlotsGrid() {
  //   final slots = controller.generateSlotsForDate(
  //     controller.selectedDate.value,
  //   );

  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //       childAspectRatio: 2.1,
  //     ),
  //     itemCount: slots.length,
  //     itemBuilder: (context, index) {
  //       final slot = slots[index];
  //       final isPast = controller.isSlotInPast(slot);
  //       final isConflict = controller.isSlotConflict(slot);
  //       final isSelected =
  //           controller.selectedSlot.value?.isAtSameMomentAs(slot) ?? false;

  //       String formattedTime = DateFormat('h:mm a').format(slot);

  //       Color boxColor = Colors.white;
  //       Color textColor = const Color(0xFF1E293B);
  //       Color borderColor = const Color(0xFFE2E8F0);
  //       double borderWidth = 1.5;

  //       if (isPast) {
  //         boxColor = const Color(0xFFF1F5F9);
  //         textColor = const Color(0xFF94A3B8);
  //       } else if (isConflict) {
  //         boxColor = const Color(0xFFFEF2F2);
  //         textColor = const Color(0xFFEF4444);
  //         borderColor = const Color(0xFFFCA5A5);
  //       } else if (isSelected) {
  //         boxColor = const Color(0xFFEEF2FF);
  //         textColor = const Color(0xFF4F46E5);
  //         borderColor = const Color(0xFF4F46E5);
  //         borderWidth = 2.0;
  //       }

  //       return InkWell(
  //         onTap: isPast || isConflict
  //             ? () {
  //                 if (isPast) {
  //                   Get.snackbar(
  //                     'Past Slot',
  //                     'This slot has already passed.',
  //                     snackPosition: SnackPosition.BOTTOM,
  //                     backgroundColor: const Color(0xFFFEF2F2),
  //                     colorText: const Color(0xFF991B1B),
  //                   );
  //                 } else {
  //                   Get.snackbar(
  //                     'Slot Booked',
  //                     'This slot has already been approved for another session.',
  //                     snackPosition: SnackPosition.BOTTOM,
  //                     backgroundColor: const Color(0xFFFEF2F2),
  //                     colorText: const Color(0xFF991B1B),
  //                   );
  //                 }
  //               }
  //             : () {
  //                 controller.selectedSlot.value = slot;
  //               },
  //         borderRadius: BorderRadius.circular(12),
  //         child: Container(
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: boxColor,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: borderColor, width: borderWidth),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 formattedTime,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 13,
  //                   color: textColor,
  //                   decoration: isPast ? TextDecoration.lineThrough : null,
  //                 ),
  //               ),
  //               if (isConflict)
  //                 const Text(
  //                   'Booked',
  //                   style: TextStyle(
  //                     fontSize: 9,
  //                     fontWeight: FontWeight.w800,
  //                     color: Color(0xFFEF4444),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
