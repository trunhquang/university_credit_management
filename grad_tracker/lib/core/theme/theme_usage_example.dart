import 'package:flutter/material.dart';
import 'theme.dart';

/// Example usage of the new theming system
class ThemeUsageExample extends StatelessWidget {
  const ThemeUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    final brandColors = context.brandColors;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Usage Example'),
        backgroundColor: colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: AppSizes.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography examples
            Text(
              'Typography Examples',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            Text(
              'Display Large',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Headline Medium',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Title Large',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Body Large',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Label Medium',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Brand colors examples
            Text(
              'Brand Colors',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                _ColorChip('Primary', brandColors.primary),
                _ColorChip('Secondary', brandColors.secondary),
                _ColorChip('Success', brandColors.success),
                _ColorChip('Warning', brandColors.warning),
                _ColorChip('Danger', brandColors.danger),
                _ColorChip('Info', brandColors.info),
              ],
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Button examples
            Text(
              'Buttons',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Card example
            Text(
              'Cards',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            Card(
              child: Padding(
                padding: AppSizes.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Title',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'This is a card with consistent padding and styling.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Input example
            Text(
              'Input Fields',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            TextField(
              decoration: InputDecoration(
                labelText: 'Example Input',
                hintText: 'Enter some text',
                prefixIcon: Icon(
                  Icons.search,
                  size: AppSizes.iconMd,
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Chip examples
            Text(
              'Chips',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                Chip(label: Text('Default')),
                Chip(
                  label: Text('Selected'),
                  selected: true,
                ),
                Chip(
                  label: Text('Success'),
                  backgroundColor: brandColors.successLight,
                ),
                Chip(
                  label: Text('Warning'),
                  backgroundColor: brandColors.warningLight,
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Spacing examples
            Text(
              'Spacing System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            
            Container(
              padding: AppSizes.paddingXs,
              decoration: BoxDecoration(
                color: brandColors.primaryLight,
                borderRadius: AppSizes.radiusXsAll,
              ),
              child: Text('XS Padding (${AppSizes.xs}px)'),
            ),
            const SizedBox(height: AppSizes.sm),
            
            Container(
              padding: AppSizes.paddingSm,
              decoration: BoxDecoration(
                color: brandColors.secondaryLight,
                borderRadius: AppSizes.radiusSmAll,
              ),
              child: Text('SM Padding (${AppSizes.sm}px)'),
            ),
            const SizedBox(height: AppSizes.md),
            
            Container(
              padding: AppSizes.paddingMd,
              decoration: BoxDecoration(
                color: brandColors.accent.withOpacity(0.2),
                borderRadius: AppSizes.radiusMdAll,
              ),
              child: Text('MD Padding (${AppSizes.md}px)'),
            ),
            const SizedBox(height: AppSizes.lg),
            
            Container(
              padding: AppSizes.paddingLg,
              decoration: BoxDecoration(
                color: brandColors.infoLight,
                borderRadius: AppSizes.radiusLgAll,
              ),
              child: Text('LG Padding (${AppSizes.lg}px)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  
  const _ColorChip(this.label, this.color);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.paddingSm,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSizes.radiusSmAll,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
