import SwiftUI

struct BackgroundHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

public struct StickyHeaderView<Header: View, Gradient: View, Content: View>: View {
    @ViewBuilder let header: () -> Header
    @ViewBuilder let gradient: () -> Gradient
    @ViewBuilder let content: () -> Content

    public init(header: @escaping () -> Header, gradient: @escaping () -> Gradient, content: @escaping () -> Content) {
        self.header = header
        self.gradient = gradient
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    header()
                        .frame(maxWidth: .infinity)
                        .background(GeometryReader { geometry in
                            Color.clear.preference(
                                key: BackgroundHeightPreferenceKey.self,
                                value: geometry.frame(in: .global).maxY
                            )
                        })

                    content()
                }
            }
            .frame(maxWidth: .infinity)
            .backgroundPreferenceValue(BackgroundHeightPreferenceKey.self, alignment: .top) { value in
                // It seems, the background must go behind the ScrollView to go under the navigation bar
                gradient()
                    .frame(height: value - geometry.frame(in: .global).minY + geometry.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea(edges: .top)
            }
        }
    }
}

#if DEBUG
    struct StickyHeaderExampleView: View {
        var body: some View {
            StickyHeaderView(
                header: {
                    Image(systemName: "lasso.badge.sparkles")
                        .font(.system(size: 120))
                        .padding()
                        .foregroundStyle(.white)
                },
                gradient: {
                    RadialGradient(gradient: Gradient(stops: [.init(color: .red, location: 0), .init(color: .yellow, location: 1)]), center: .bottom, startRadius: 0, endRadius: 300)
                },
                content: {
                    VStack {
                        ForEach(1 ... 30, id: \.self) { idx in
                            Text("Hello, world! \(idx)")
                        }
                    }
                }
            )
            .navigationBarTitle("Example", displayMode: .inline)
        }
    }

    #Preview("In a sheet") {
        Color.yellow
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    StickyHeaderExampleView()
                }
            }
    }

    #Preview("Standalone") {
        NavigationStack {
            StickyHeaderExampleView()
        }
    }
#endif
