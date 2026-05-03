// class MealsApprovalTabs extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onTap;

//   const MealsApprovalTabs({
//     super.key,
//     required this.selectedIndex,
//     required this.onTap,
//   });

//   static const _tabs = ['All', 'Pending', 'Rejected'];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: kCard,
//       child: Row(
//         children: List.generate(_tabs.length, (i) {
//           final selected = i == selectedIndex;
//           return GestureDetector(
//             onTap: () => onTap(i),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                     color: selected ? kPrimary : Colors.transparent,
//                     width: 2,
//                   ),
//                 ),
//               ),
//               child: Text(
//                 _tabs[i],
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
//                   color: selected ? kPrimary : kMuted,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }